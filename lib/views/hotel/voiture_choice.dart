import 'package:flutter/material.dart';

class VoitureChoice extends StatelessWidget {
  final Function(String) onCarSelected;

  const VoitureChoice({Key? key, required this.onCarSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> carImages = [
      'assets/corolla.png',
      'assets/fortuner.png',
      'assets/mercedese.png',
      'assets/santafe.png',
      'assets/tesla.png',
      'assets/nissanpngwing.png',
      'assets/tucson.png'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir une Voiture'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: carImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onCarSelected(carImages[index]);
            },
            child: Card(
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(carImages[index], fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 8),
                  const Text('Car Model', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Price: \$50'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
