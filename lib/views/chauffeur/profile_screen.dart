import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/services/auth_service.dart';
import 'package:trust_reservation_second/services/chauffeur_service.dart';
import 'package:trust_reservation_second/views/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ChauffeurService _chauffeurService = ChauffeurService();
  final AuthService _authService = AuthService();
  late Future<Response> _chauffeurData;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _telephoneController;
  late TextEditingController _emailController;
  late TextEditingController _adresseController;
  String? _photoUrl;
  File? _image;

  @override
  void initState() {
    super.initState();
    _chauffeurData = _chauffeurService.getChauffeurInfo();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _telephoneController = TextEditingController();
    _emailController = TextEditingController();
    _adresseController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : const AssetImage('assets/icon_profile.png') as ImageProvider,
              ),
              const SizedBox(height: 8),
              const Text(
                'Changer photo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  child: const Text('Prendre une photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsApp.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text('Choisir de la galerie'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _updateChauffeurInfo() async {
    final data = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'telephone': _telephoneController.text,
      'email': _emailController.text,
      'adresse': _adresseController.text,
    };

    final response = await _chauffeurService.updateChauffeur(data);

    if (response.statusCode == 200) {
      setState(() {
        _chauffeurData = _chauffeurService.getChauffeurInfo();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informations mises à jour avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${response.statusMessage}')),
      );
    }
  }

  void _showEditDialog(BuildContext context, String title, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier $title'),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Entrez $title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateChauffeurInfo();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration de l'Hôtel"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Response>(
        future: _chauffeurData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            var data = snapshot.data!.data;
            _firstNameController.text = data['first_name'];
            _lastNameController.text = data['last_name'];
            _telephoneController.text = data['telephone'];
            _emailController.text = data['email'];
            _adresseController.text = data['adresse'];
            _photoUrl = data['photo'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                 CircleAvatar(
  radius: 50,
  backgroundImage: (_photoUrl != null && _photoUrl!.isNotEmpty)
      ? NetworkImage('$_photoUrl?${DateTime.now().millisecondsSinceEpoch}')
      : const AssetImage('assets/icon_profile.png') as ImageProvider,
  onBackgroundImageError: (exception, stackTrace) {
    if (kDebugMode) {
      print('Erreur de chargement de l\'image: $exception');
    }
  },
),
                  const SizedBox(height: 8),
                  Text(
                    '${_firstNameController.text} ${_lastNameController.text}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      _showPhotoOptions(context);
                    },
                    child: const Text(
                      'Changer photo',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildOption(context, 'Nom', Icons.person, _firstNameController),
                  _buildOption(context, 'Prénom', Icons.person_outline, _lastNameController),
                  _buildOption(context, 'Numéro de téléphone', Icons.phone, _telephoneController),
                  _buildOption(context, 'Email', Icons.email, _emailController),
                  _buildOption(context, 'Adresse', Icons.home, _adresseController),
                  const Spacer(),
                  TextButton(
                    onPressed: _updateChauffeurInfo,
                    child: const Text(
                      'Modifier les informations',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: _logout,
                    child: const Text(
                      'Fermer session',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text('Aucune donnée');
          }
        },
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, IconData icon, TextEditingController controller) {
    return GestureDetector(
      onTap: () {
        _showEditDialog(context, title, controller);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Icon(icon, color: ColorsApp.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration.collapsed(hintText: title),
                style: const TextStyle(fontSize: 16),
                readOnly: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
