import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/widgets/custom_icon_button.dart';

class PersonalInformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations personnelles'),
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField('Nom complet', 'Nom complet'),
            _buildTextField('Adresse électronique', 'email@example.com'),
            _buildTextField('Numéro de téléphone', 'Téléphone',
                prefixIcon: Icons.flag),
            _buildTextField('Date de naissance', 'AAAA/MM/JJ',
                suffixIcon: Icons.calendar_today),
            _buildDropdownField('Département', ['Option 1', 'Option 2']),
            _buildDropdownField('Ville', ['Option 1', 'Option 2']),
            _buildTextField('Adresse de résidence', 'Adresse'),
            SizedBox(height: 20),
            CustomIconButton(
              icon: Icons.save,
              label: "enregister",
              color: ColorsApp.primaryColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      {IconData? prefixIcon, IconData? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          // Handle dropdown change
        },
      ),
    );
  }
}
