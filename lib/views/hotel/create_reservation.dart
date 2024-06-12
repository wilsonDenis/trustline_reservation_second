import 'package:flutter/material.dart';

class CreateReservation extends StatelessWidget {
  const CreateReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Reservation'),
      ),
      body: const Center(
        child: Text('Create Reservation Page'),
      ),
    );
  }
}
