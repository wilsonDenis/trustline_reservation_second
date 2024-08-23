import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/services/user_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/views/individual_chat_page.dart';

class UserListPage extends StatelessWidget {
  final UserService _userService = UserService();

  UserListPage({super.key});

  Future<Map<String, String>> _getCurrentUserInfo() async {
    final userId = await LocalStorageService.getData('userId');
    final userType = await LocalStorageService.getData('user_type');
    if (userId == null || userType == null) {
      throw Exception('User ID or Type not found');
    }
    return {'userId': userId.toString(), 'userType': userType.toString()};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chauffeurs"),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, String>>(
          future: _getCurrentUserInfo(),
          builder: (context, userInfoSnapshot) {
            if (userInfoSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (userInfoSnapshot.hasError) {
              return Center(child: Text('Erreur: ${userInfoSnapshot.error}'));
            }

            var currentUserId = userInfoSnapshot.data!['userId']!;
            var currentUserType = userInfoSnapshot.data!['userType']!;

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _userService.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun utilisateur trouvé.'));
                }

                // Filtrer les utilisateurs en fonction du type de l'utilisateur actuel
                var filteredUsers = snapshot.data!.where((user) {
                  if (currentUserType == 'chauffeur') {
                    return user['type_utilisateur'] == 'hotel';
                  } else if (currentUserType == 'hotel') {
                    return user['type_utilisateur'] == 'chauffeur';
                  }
                  return false;
                }).toList();

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    var user = filteredUsers[index];
                    var photoUrl = user['photo'] ?? '';
                    var userName = "${user['first_name']} ${user['last_name']}".trim();
                    var userEmail = user['email'] ?? 'Email non disponible';
                    var isActive = user['is_active'] ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: photoUrl.isNotEmpty
                                  ? NetworkImage(photoUrl)
                                  : const AssetImage('assets/default_profile.png') as ImageProvider,
                            ),
                            if (isActive)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          userName.isNotEmpty ? userName : 'Utilisateur',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 128, 0)),
                        ),
                        subtitle: Text(userEmail),
                        onTap: () {
                          var userId = user['id']?.toString() ?? '0';
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => IndividualChatPage(
                                user1Id: currentUserId,
                                user2Id: userId,
                                user2Name: userName.isNotEmpty ? userName : 'Utilisateur',
                                user2PhotoUrl: photoUrl,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
