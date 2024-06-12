import 'package:flutter/material.dart';

class Messaging extends StatelessWidget {
  const Messaging({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging'),
      ),
      body: const Center(
        child: Text('Messaging Page'),
      ),
    );
  }
}
