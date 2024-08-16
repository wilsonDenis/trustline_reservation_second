import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/services/user_service.dart';
import 'package:trust_reservation_second/views/hotel/add_receptionist_screen.dart';
import 'package:trust_reservation_second/views/hotel/edit_receptionnist.dart';

import '../../constants/colors_app.dart';

class ListReceptionnistesScreen extends StatefulWidget {
  const ListReceptionnistesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListReceptionnistesScreenState createState() => _ListReceptionnistesScreenState();
}

class _ListReceptionnistesScreenState extends State<ListReceptionnistesScreen> {
  final UserService _userService = UserService();
  List<dynamic> _receptionnistes = [];

  @override
  void initState() {
    super.initState();
    _fetchReceptionnistes();
  }

  // Fonction pour récupérer la liste des réceptionnistes
  Future<void> _fetchReceptionnistes() async {
    final response = await _userService.getReceptionnistes();
    if (response.statusCode == 200) {
      setState(() {
        _receptionnistes = response.data;
      });
    }
  }

  // Fonction pour supprimer un réceptionniste
  Future<void> _deleteReceptionniste(int id) async {
    final response = await _userService.deleteReceptionniste(id);
    if (response.statusCode == 204) {
      _fetchReceptionnistes();
    }
  }

  // Fonction pour afficher les options de modification et de suppression
  void _showOptionsDialog(Map<String, dynamic> receptionist) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title:const Text('Options'),
          content: Text('Choisissez une action pour ${receptionist['nom']} ${receptionist['prenom']}'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Modifier'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditReceptionistScreen(receptionist: receptionist),
                  ),
                ).then((_) => _fetchReceptionnistes()); // Rafraîchir la liste après modification
              },
            ),
            CupertinoDialogAction(
              child: const Text('Supprimer'),
              onPressed: () {
                Navigator.of(context).pop();
                _showDeleteConfirmationDialog(receptionist['id']);
              },
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher la confirmation de suppression
  void _showDeleteConfirmationDialog(int id) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Confirmation de suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce réceptionniste?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Supprimer'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReceptionniste(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          color: CupertinoColors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: const Text('Réceptionnistes'),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: CupertinoScrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _receptionnistes.length,
                itemBuilder: (context, index) {
                  final receptionist = _receptionnistes[index];
                  return GestureDetector(
                    onLongPress: () {
                      _showOptionsDialog(receptionist);
                    },
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {}, // Ajoutez une action ici si nécessaire
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: const Icon(CupertinoIcons.person),
                          title: Text('${receptionist['nom']} ${receptionist['prenom']}'),
                          subtitle: Text(receptionist['email']),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              backgroundColor: ColorsApp.primaryColor, // Couleur personnalisée
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddReceptionistScreen(),
                  ),
                ).then((_) => _fetchReceptionnistes()); // Rafraîchir la liste après ajout
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
