import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool readOnly;
  final TextInputType keyboardType;
  final Color borderColor; // Nouvelle propriété pour la couleur de la bordure
  final double borderWidth;
  final String? Function(String?)? validator;
  final IconData? prefixIcon; // Icône préfixe optionnelle
  final IconData? suffixIcon; // Icône suffixe optionnelle
  final Color? prefixIconColor; // Couleur de l'icône préfixe
  final Color? suffixIconColor; // Couleur de l'icône suffixe

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconColor,
    this.suffixIconColor,
    this.readOnly = false,
    this.borderColor = Colors.grey, // Valeur par défaut de la couleur de la bordure
    this.borderWidth = 1.0,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: widget.prefixIconColor)
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.borderColor, // Utilisation de la couleur de la bordure
            width: widget.borderWidth, // Utilisation de la largeur de la bordure
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.borderColor, // Utilisation de la couleur de la bordure
            width: widget.borderWidth, // Utilisation de la largeur de la bordure
          ),
        ),
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                icon: Icon(widget.suffixIcon, color: widget.suffixIconColor),
                onPressed: () {
                  if (widget.suffixIcon == Icons.visibility || widget.suffixIcon == Icons.visibility_off) {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  }
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
