import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';
import 'package:trust_reservation_second/widgets/custom_text_form_field.dart';
import 'package:trust_reservation_second/services/location_service.dart';

class ConfigurationHotel extends StatefulWidget {
  const ConfigurationHotel({super.key});

  @override
  State<ConfigurationHotel> createState() => _ConfigurationHotelState();
}

class _ConfigurationHotelState extends State<ConfigurationHotel> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  List<String> _addressSuggestions = [];

  @override
  void initState() {
    super.initState();
    _loadHotelDetails();
    _loadAddressSuggestions();
  }

  Future<void> _loadHotelDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('hotel_name') ?? '';
      _phoneController.text = prefs.getString('hotel_phone') ?? '';
      _addressController.text = prefs.getString('hotel_address') ?? 'Adresse de l\'hôtel';
      _emailController.text = prefs.getString('hotel_email') ?? '';
      _websiteController.text = prefs.getString('hotel_website') ?? '';
    });
  }

  Future<void> _saveHotelDetails() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('hotel_name', _nameController.text);
    prefs.setString('hotel_phone', _phoneController.text);
    prefs.setString('hotel_address', _addressController.text);
    prefs.setString('hotel_email', _emailController.text);
    prefs.setString('hotel_website', _websiteController.text);
  }

  Future<void> _loadAddressSuggestions() async {
    _addressSuggestions = (await LocationService.getSuggestions("")).cast<String>();
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
                          "Configuration de l'Hôtel",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: 'Nom de l\'hôtel',
                        hintText: 'Entrez le nom de l\'hôtel',
                        prefixIcon: Icons.hotel,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom de l\'hôtel';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _phoneController,
                        labelText: 'Numéro de téléphone',
                        hintText: 'Entrez le numéro de téléphone',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le numéro de téléphone';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _addressController.text,
                        items: _addressSuggestions.map((String address) {
                          return DropdownMenuItem<String>(
                            value: address,
                            child: Text(address),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _addressController.text = newValue ?? '';
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Adresse',
                          hintText: 'Entrez l\'adresse',
                          prefixIcon:  Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _emailController,
                        labelText: 'Email',
                        hintText: 'Entrez l\'email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer l\'email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _websiteController,
                        labelText: 'Site Web',
                        hintText: 'Entrez le site web (optionnel)',
                        prefixIcon: Icons.web,
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!(Uri.tryParse(value)?.hasAbsolutePath ?? false)) {
                              return 'Veuillez entrer une URL valide';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: CustomButton(
                          onPressed: () {
                            if (_nameController.text.isNotEmpty &&
                                _phoneController.text.isNotEmpty &&
                                _addressController.text.isNotEmpty &&
                                _emailController.text.isNotEmpty) {
                              _saveHotelDetails();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Détails de l\'hôtel enregistrés avec succès'),
                                ),
                              );
                            }
                          },
                          text: 'Enregistrer',
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
