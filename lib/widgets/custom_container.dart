// custom_container.dart
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final VoidCallback onTap;
  final bool showIconInsteadOfCount;
  final double? width;
  final double? height;

  const CustomContainer({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.onTap,
    this.showIconInsteadOfCount = false, // Ajoutez ce paramètre
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 150, // Utilisez la largeur par défaut si non spécifiée
        height:
            height ?? 100, // Utilisez la hauteur par défaut si non spécifiée
        padding: const EdgeInsets.all(8),
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
                  showIconInsteadOfCount
                      ? Icon(icon, size: 40, color: color)
                      : Text(
                          count.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
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

// class CustomContainer extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final int count;
//   final Color color;
//   final VoidCallback onTap;

//   const CustomContainer({
//     required this.icon,
//     required this.title,
//     required this.count,
//     required this.color,
//     required this.onTap,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 150, // Set the width
//         height: 100, // Set the height
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 6,
//               offset: const Offset(0, 2), // changes position of shadow
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: 8,
//               right: 8,
//               child: Icon(icon, size: 24, color: color),
//             ),
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     count.toString(),
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
