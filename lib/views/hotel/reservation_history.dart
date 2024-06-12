import 'package:flutter/material.dart';

class ReservationHistory extends StatelessWidget {
  const ReservationHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation History'),
      ),
      body: const Center(
        child: Text('Reservation History Page'),
      ),
    );
  }
}
