import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/services/user_service.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';
import 'package:trust_reservation_second/widgets/custom_text_form_field.dart';

class EditReceptionistScreen extends StatefulWidget {
  final Map<String, dynamic> receptionist;

  const EditReceptionistScreen({required this.receptionist, super.key});

  @override
  State<EditReceptionistScreen> createState() => _EditReceptionistScreenState();
}

class _EditReceptionistScreenState extends State<EditReceptionistScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "${widget.receptionist['prenom']} ${widget.receptionist['nom']}");
    _emailController = TextEditingController(text: widget.receptionist['email']);
  }

  Future<void> _updateReceptionistDetails() async {
    final name = _nameController.text;
    final email = _emailController.text;

    // Obtenez l'ID de l'hôtel (vous devrez peut-être l'ajouter à votre interface ou le récupérer d'une autre manière)
    final hotelId = await LocalStorageService.getData('specific_id');

    try {
      final UserService userService = UserService();
      final response = await userService.updateReceptionniste(widget.receptionist['id'], {
        'nom': name.split(' ').last, // Supposant que le nom est le dernier mot
        'prenom': name.split(' ').first, // Supposant que le prénom est le premier mot
        'email': email,
        'hotel_id': hotelId,
      });

      if (response.statusCode == 200 || response.statusCode == 204) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receptionist updated successfully')),
        );
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to update receptionist');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email invalide ou déjà existant')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    borderRadius: BorderRadius.circular(20),
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
                      const Center(
                        child: Text(
                          "Edit Receptionist",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: 'Name',
                        hintText: 'Enter name',
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the name';
                          }
                          return null;
                        },
                        obscureText: false,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _emailController,
                        labelText: 'Email',
                        hintText: 'Enter email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        obscureText: false,
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: CustomButton(
                          onPressed: () async {
                            if (_nameController.text.isNotEmpty &&
                                _emailController.text.isNotEmpty) {
                              await _updateReceptionistDetails();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all fields')),
                              );
                            }
                          },
                          text: 'Update Receptionist',
                          backgroundColor: Colors.blue,
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
