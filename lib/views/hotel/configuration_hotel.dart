import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_reservation_second/services/location_service.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';
import 'package:trust_reservation_second/widgets/custom_text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
  String? _selectedImagePath;
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
    if (_selectedImagePath != null) {
      prefs.setString('hotel_image', _selectedImagePath!);
    }
  }

  Future<void> _loadAddressSuggestions() async {
    _addressSuggestions = (await LocationService.getSuggestions("")).cast<String>();
  }

  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImagePath == null) return;

    File imageFile = File(_selectedImagePath!);
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    String fileName = imageFile.path.split("/").last;

    var response = await http.post(
      Uri.parse("YOUR_API_ENDPOINT"),
      body: {
        "image": base64Image,
        "name": fileName,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploadée avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec du téléchargement de l\'image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration de l'Hôtel"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black), // Icune de retour personnalisée
          onPressed: () {
            Navigator.pop(context); // Retourne à la page précédente
          },
        ),
        centerTitle: true,
      
      ),
      body: //Center(
      SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                obscureText: false,
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
                obscureText: false,
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
                  prefixIcon: const Icon(Icons.location_on),
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
                obscureText: false,
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
                obscureText: false,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectImage,
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    controller: TextEditingController(text: _selectedImagePath != null ? "Image sélectionnée" : ""),
                    labelText: 'Image',
                    hintText: 'Choisissez une image',
                    prefixIcon: Icons.image,
                    validator: (value) {
                      return null;
                    },
                    obscureText: false,
                  ),
                ),
              ),
              const SizedBox(height: 180),
              Center(
                child: CustomButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _phoneController.text.isNotEmpty &&
                        _addressController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty) {
                      await _saveHotelDetails();
                      await _uploadImage();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Détails de l\'hôtel enregistrés avec succès'),
                        ),
                      );
                    }
                  },
                  text: 'Enregistrer',
                ),
              ),//
            ],
          ),
        ),
    //  ),
    );
  }
}
