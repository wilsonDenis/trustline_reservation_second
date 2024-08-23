import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool disabled; 

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false, required MaterialColor backgroundColor,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed, // Désactivé si 'disabled' est true
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : ColorsApp.primaryColor,
          side: isOutlined
              ? const BorderSide(color: Colors.white)
              : BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          minimumSize: const Size(88, 50), // Minimum size for ElevatedButton
        ),
       
        child: Text(
          text,
          style: TextStyle(
            color: isOutlined ? ColorsApp.primaryColor : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

