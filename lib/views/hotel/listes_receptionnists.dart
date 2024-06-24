import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/views/admin/gerant_recept_auth.dart';
import 'package:trust_reservation_second/views/hotel/add_receptionist_screen.dart';

class ListesReceptionnists extends StatelessWidget {
  final List<Map<String, dynamic>> receptionists = [
    {'name': 'Zacher mils', 'password': 'xxxxxx'},
    {'name': 'Jane smith', 'password': 'xxxxxxx'},
    // Ajoutez plus de réceptionnistes ici pour la simulation
  ];

  ListesReceptionnists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black), // Icune de retour personnalisée
          onPressed: () {
            Navigator.pop(context); // Retourne à la page précédente
          },
        ),
        centerTitle: true,
        title: const Text('Receptionists'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: receptionists.length,
        itemBuilder: (context, index) {
          final receptionist = receptionists[index];
          return GestureDetector(
            onLongPress: () {
              _showOptionsDialog(context, receptionist);
            },
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(receptionist['name']),
                subtitle: Text(receptionist['password']),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GerantReceptAuth()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, Map<String, dynamic> receptionist) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Options'),
          content: Text('Choose an action for ${receptionist['name']}'),
          actions: [
            TextButton(
              child: const Text('Modify'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/edit_receptionist', arguments: receptionist);
              },
            ),
            TextButton(
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete ${receptionist['name']}?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
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
