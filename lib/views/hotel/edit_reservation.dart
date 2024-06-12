import 'package:flutter/material.dart';

class EditReservation extends StatelessWidget {
  const EditReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text('Edit Reservation'),
      ),
      body: const Center(
        child: Text('Edit Reservation Page'),
      ),
    );
  }
}
