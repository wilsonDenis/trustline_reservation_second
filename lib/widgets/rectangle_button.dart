import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RectangleButton extends StatelessWidget {
  Function() onPressed;
  String buttonText;
  Color buttonColor;
  Color textColor;
  double buttonWidth;
  final IconData? icon;
  final Color? iconColor;
  RectangleButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      required this.buttonColor,
      required this.textColor,
      this.icon,
      this.iconColor,
      required this.buttonWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(0),
          height: 60,
          width: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: buttonColor,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buttonText,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (icon != null) // Vérifier si l'icône est fournie
                  Icon(
                    icon!, // Utiliser l'icône fournie
                    color: iconColor ??
                        textColor, // Utiliser la couleur de l'icône fournie ou la couleur du texte par défaut
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
