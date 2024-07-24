import 'package:flutter/material.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';

// Définit un typedef pour la fonction de soumission de contact
typedef ContactSubmittedCallback = void Function(String name, String phone, String email);

class ContactForm extends StatelessWidget {
  final ContactSubmittedCallback onContactSubmitted;

  const ContactForm({Key? key, required this.onContactSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire de Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Téléphone'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () {
                // Appelle la fonction de rappel avec les valeurs des contrôleurs de texte
                onContactSubmitted(
                  _nameController.text,
                  _phoneController.text,
                  _emailController.text,
                );
              },
              text: 'Soumettre',
              backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
