import 'package:flutter/material.dart';

class HistoryReservations extends StatefulWidget {
  // ignore: use_super_parameters
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation History'),
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
              title: Text(reservation['name']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address: ${reservation['address']}'),
                  Text('Time: ${reservation['time']}'),
                  Text('Reserved by: ${reservation['reservedBy']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}