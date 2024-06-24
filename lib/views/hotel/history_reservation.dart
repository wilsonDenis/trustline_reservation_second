import 'package:flutter/material.dart';
import 'package:trust_reservation_second/views/hotel/facture_details_screen.dart';

class HistoryReservations extends StatefulWidget {
  const HistoryReservations({Key? key}) : super(key: key);

  @override
  State<HistoryReservations> createState() => _HistoryReservationsState();
}

class _HistoryReservationsState extends State<HistoryReservations> {
  final List<Map<String, String>> reservations = [
    {
      'name': 'Reservation 1',
      'address': '123 Main St',
      'time': '10:00 AM',
      'reservedBy': 'Will Smith',
    },
    {
      'name': 'Reservation 2',
      'address': '456 Elm St',
      'time': '12:00 PM',
      'reservedBy': 'Will Smith',
    },
    {
      'name': 'Reservation 3',
      'address': '789 Maple St',
      'time': '2:00 PM',
      'reservedBy': 'Will Smith',
    },
  ];

  void _showInvoiceOptions(BuildContext context, Map<String, String> reservation) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('facture'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FactureDetailsScreen(reservation: reservation),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Modify Reservation'),
              onTap: () {
                Navigator.of(context).pop();
                // Navigate to modification screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel Reservation'),
              onTap: () {
                Navigator.of(context).pop();
                // Handle cancellation
              },
            ),
           
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique reservations'),
         leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black), // Icune de retour personnalisée
          onPressed: () {
            Navigator.pop(context); // Retourne à la page précédente
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.event, color: Colors.blue),
              title: Text(
                reservation['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address: ${reservation['address']}'),
                  Text('Time: ${reservation['time']}'),
                  Text('Reserved by: ${reservation['reservedBy']}'),
                ],
              ),
              onTap: () => _showInvoiceOptions(context, reservation),
            ),
          );
        },
      ),
    );
  }
}