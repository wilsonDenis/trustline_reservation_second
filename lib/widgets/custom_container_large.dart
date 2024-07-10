import 'package:flutter/material.dart';

class CustomContainerLarge extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const CustomContainerLarge({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Set the width to be full width
        height: 150, // Increased height for more space
        padding:
            const EdgeInsets.all(16), // Increased padding for better spacing
        margin: const EdgeInsets.symmetric(
            vertical: 10), // Margin for spacing between items
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 8,
              child: Icon(icon, size: 24, color: color),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
