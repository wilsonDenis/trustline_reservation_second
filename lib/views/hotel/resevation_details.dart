import 'package:flutter/material.dart';

class ReservationDetails extends StatelessWidget {
  const ReservationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
      ),
      body: const Center(
        child: Text('Reservation Details Page'),
      ),
    );
  }
}
