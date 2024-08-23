import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/services/user_service.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';
import 'package:trust_reservation_second/widgets/custom_text_form_field.dart';

class AddReceptionistScreen extends StatefulWidget {
  const AddReceptionistScreen({super.key});

  @override
  State<AddReceptionistScreen> createState() => _AddReceptionistScreenState();
}

class _AddReceptionistScreenState extends State<AddReceptionistScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _saveReceptionistDetails() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('receptionist_name', _nameController.text);
    prefs.setString('receptionist_email', _emailController.text);
    prefs.setString('receptionist_password', _passwordController.text);
  }

  Future<void> _sendDetailsToAPI() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final hotelId = await LocalStorageService.getData('specific_id');

    try {
      final UserService userService = UserService();
      final response = await userService.createReceptionniste({
        'nom': name.split(' ').last,
        'prenom': name.split(' ').first,
        'email': email,
        'hotel_id': hotelId,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receptionist added successfully')),
        );
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to add receptionist');
      }
    } catch (e) {
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
                  constraints: BoxConstraints(
                    maxWidth: 600,
                    minHeight: 300,
                    maxHeight: ResponsiveBreakpoints.of(context).largerThan(TABLET) ? 400 : double.infinity,
                  ),
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
                          "Ajouter Receptionniste",
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
                      // const SizedBox(height: 24),
                      Center(
                        child: CustomButton(
                          onPressed: () async {
                            if (_nameController.text.isNotEmpty &&
                                _emailController.text.isNotEmpty) {
                              await _sendDetailsToAPI();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all fields')),
                              );
                            }
                          },
                          text: 'créer',
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
