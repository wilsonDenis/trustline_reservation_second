import 'package:flutter/material.dart';

class HotelProfile extends StatelessWidget {
  const HotelProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Profile'),
      ),
      body: const Center(
        child: Text('Hotel Profile Page'),
      ),
    );
  }
}
