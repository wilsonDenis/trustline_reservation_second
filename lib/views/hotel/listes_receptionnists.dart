import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/views/admin/gerant_recept_auth.dart';

class ListesReceptionnists extends StatelessWidget {
  final List<Map<String, dynamic>> receptionists = [
    {'name': 'Zacher mils', 'password': 'xxxxxx'},
    {'name': 'Jane smith', 'password': 'xxxxxxx'},
    // Ajoutez plus de réceptionnistes ici pour la simulation
  ];

  ListesReceptionnists({super.key});

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
        middle: const Text('Receptionists'),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: CupertinoScrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: receptionists.length,
                itemBuilder: (context, index) {
                  final receptionist = receptionists[index];
                  return GestureDetector(
                    onLongPress: () {
                      _showOptionsDialog(context, receptionist);
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
                          title: Text(receptionist['name']),
                          subtitle: Text(receptionist['password']),
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
                  CupertinoPageRoute(builder: (context) => const GerantReceptAuth()),
                );
              },
              child: const Icon(Icons.add,color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, Map<String, dynamic> receptionist) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Options'),
          content: Text('Choose an action for ${receptionist['name']}'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Modify'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/edit_receptionist', arguments: receptionist);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _showDeleteConfirmationDialog(context, receptionist);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> receptionist) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete ${receptionist['name']}?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                // Perform deletion action here
                if (kDebugMode) {
                  print('Deleted ${receptionist['name']}');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
