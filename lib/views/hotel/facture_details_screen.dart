import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';

class FactureDetailsScreen extends StatelessWidget {
  final Map<String, String> reservation;

  const FactureDetailsScreen({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
         leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black), // Icune de retour personnalisée
          onPressed: () {
            Navigator.pop(context); // Retourne à la page précédente
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/carousel_image_4.jpg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation['name']!,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text('Address: ${reservation['address']}'),
                      Text('Time: ${reservation['time']}'),
                      Text('Reserved by: ${reservation['reservedBy']}'),
                      const SizedBox(height: 24),
                      const Text(
                        'Invoice Details:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text('Invoice Number: 123456'),
                      const Text('Invoice Date: 2023-06-01'),
                      const Text('Due Date: 2023-06-15'),
                      const Text('Amount: \$100.00'),
                      const Text('Tax: \$5.00'),
                      const Text('Total Amount: \$105.00'),
                      const SizedBox(height: 24),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CustomIconButton(
                                onPressed: () {
                                  // Handle modification
                                },
                                icon: Icons.edit,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomIconButton(
                                onPressed: () {
                                  // Handle cancellation
                                },
                                icon: Icons.cancel,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomIconButton(
                                onPressed: () {
                                  // Handle change
                                },
                                icon: Icons.swap_horiz,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const CustomIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsApp.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
