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
  final IconData prefixIcon;
  final bool
      showSuffixIcon; // Ajout d'un booléen pour contrôler l'affichage du suffixIcon

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.validator,
    required this.prefixIcon,
    this.readOnly=false,
    this.borderColor =
        Colors.grey, // Valeur par défaut de la couleur de la bordure
    this.borderWidth = 1.0,
    this.showSuffixIcon = false, // Valeur par défaut à true
  });

  @override
  // ignore: library_private_types_in_public_api
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
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        
        prefixIcon: Icon(widget.prefixIcon),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color:
                widget.borderColor, // Utilisation de la couleur de la bordure
            width:
                widget.borderWidth, // Utilisation de la largeur de la bordure
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color:
                widget.borderColor, // Utilisation de la couleur de la bordure
            width:
                widget.borderWidth, // Utilisation de la largeur de la bordure
          ),
        ),
        suffixIcon: widget.showSuffixIcon
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null, // Utilisation de showSuffixIcon pour contrôler l'affichage
      ),
      validator: widget.validator,
    );
  }
}
