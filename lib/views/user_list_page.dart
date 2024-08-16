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
      appBar: AppBar(title: const Text("Liste des utilisateurs")),
      body: FutureBuilder<Map<String, String>>(
        future: _getCurrentUserInfo(),
        builder: (context, userInfoSnapshot) {
          if (userInfoSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userInfoSnapshot.hasError) {
            return Center(child: Text('Erreur: ${userInfoSnapshot.error}'));
          }

          var currentUserId = userInfoSnapshot.data!['userId']!;
          var currentUserType = userInfoSnapshot.data!['userType']!;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _userService.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucun utilisateur trouvé.'));
              }

              // Filtrer les utilisateurs selon le type actuel
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
                  var userName = "${user['first_name']} ${user['last_name']}";
                  var userEmail = user['email'] ?? 'Email non disponible';
                  var isActive = user['is_active'] ?? false;

                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: photoUrl.isNotEmpty
                              ? NetworkImage(photoUrl)
                              : const AssetImage('assets/default_profile.png') as ImageProvider,
                        ),
                        if (isActive)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(userName),
                    subtitle: Text(userEmail),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividualChatPage(
                            user1Id: currentUserId,
                            user2Id: user['id'].toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
