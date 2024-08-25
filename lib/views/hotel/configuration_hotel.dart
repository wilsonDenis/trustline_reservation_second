import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/services/location_service.dart';
import 'package:trust_reservation_second/services/user_service.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';
import 'package:trust_reservation_second/widgets/custom_text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

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
  final UserService _userService = UserService();
  // ignore: unused_field
  int? _entrepriseId;  // Pour stocker l'ID de l'entreprise
  // ignore: unused_field
  int? _gerantId;  // Pour stocker l'ID du gérant

  @override
  void initState() {
    super.initState();
    _loadHotelDetails();
    _loadAddressSuggestions();
  }

  Future<void> _loadHotelDetails() async {
    final specificId = await LocalStorageService.getData('specific_id');
    if (specificId == null) return; // ID non trouvé

    try {
      final response = await _userService.getHotelInfo(specificId);
      if (response.statusCode == 200) {
        final hotelInfo = response.data;
        setState(() {
          _nameController.text = hotelInfo['nom'] ?? '';
          _phoneController.text = hotelInfo['telephone'] ?? '';
          _addressController.text = hotelInfo['adresse'] ?? '';
          _emailController.text = hotelInfo['email'] ?? '';
          _websiteController.text = hotelInfo['site_web'] ?? '';
          _selectedImagePath = hotelInfo['photo'] ?? ''; // Gérer l'image de l'hôtel
          _entrepriseId = hotelInfo['entreprise'];  // Récupérer l'ID de l'entreprise
          _gerantId = hotelInfo['gerant']['id'];  // Récupérer l'ID du gérant
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Échec du chargement des informations de l\'hôtel')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
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
Future<void> _updateHotelDetails() async {
  final specificId = await LocalStorageService.getData('specific_id');
  if (specificId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ID du gérant non trouvé')),
    );
    return;
  }

  FormData formData = FormData.fromMap({
    'nom': _nameController.text,
    'telephone': _phoneController.text,
    'adresse': _addressController.text,
    'email': _emailController.text,
    'site_web': _websiteController.text,
    'entreprise': 1,  // Utilisez l'ID réel de l'entreprise
    'gerant': specificId, // Utilisation de l'ID du gérant à partir du local storage
  });

  if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty) {
    if (File(_selectedImagePath!).existsSync()) {
      formData.files.add(
        MapEntry(
          'photo',
          await MultipartFile.fromFile(_selectedImagePath!, filename: 'photo.jpg'),
        ),
      );
    } else {
      formData.fields.add(MapEntry('photo', _selectedImagePath!)); // Si c'est une URL existante
    }
  }

  try {
    var response = await _userService.updateHotel(formData, isFormData: true);
    if (response.statusCode == 200) {
      await _saveHotelDetails();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Détails de l\'hôtel enregistrés avec succès')),
      );
      Navigator.pop(context, true); // Retourne à la page précédente avec succès
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la mise à jour des détails de l\'hôtel: ${response.data}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur: $e')),
    );
  }
}


  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration de l'Hôtel"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Retourne à la page précédente
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                  controller: TextEditingController(
                      text: _selectedImagePath != null
                          ? "Image sélectionnée"
                          : ""),
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
                    await _updateHotelDetails();
                  }
                },
                text: 'Enregistrer',
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
