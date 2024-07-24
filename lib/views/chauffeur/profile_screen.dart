import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/services/auth_service.dart';
import 'package:trust_reservation_second/services/chauffeur_service.dart';
import 'package:dio/dio.dart';
import 'dart:io';

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
      shape: RoundedRectangleBorder(
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
                    : AssetImage('assets/icon_profile.png') as ImageProvider,
              ),
              SizedBox(height: 8),
              Text(
                'Changer photo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  child: Text('Prendre une photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsApp.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  child: Text('Choisir de la galerie'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration de l'Hôtel"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp,
              color: Colors.black), // Icune de retour personnalisée
          onPressed: () {
            Navigator.pop(context); // Retourne à la page précédente
          },
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Response>(
        future: _chauffeurData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                  SizedBox(height: 40),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _photoUrl != null
                        ? NetworkImage('https://laconciergerie-i-carre.com/testApi$_photoUrl')
                        : AssetImage('assets/icon_profile.png') as ImageProvider,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${_firstNameController.text} ${_lastNameController.text}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      _showPhotoOptions(context);
                    },
                    child: Text(
                      'Changer photo',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildOption(context, 'Nom', Icons.person, _firstNameController),
                  _buildOption(context, 'Prénom', Icons.person_outline, _lastNameController),
                  _buildOption(context, 'Numéro de téléphone', Icons.phone, _telephoneController),
                  _buildOption(context, 'Email', Icons.email, _emailController),
                  _buildOption(context, 'Adresse', Icons.home, _adresseController),
                  Spacer(),
                  TextButton(
                    onPressed: _logout,
                    child: Text(
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
        // Logique de navigation ou modification
        // Par exemple, afficher une boîte de dialogue pour modifier les informations
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
            SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration.collapsed(hintText: title),
                style: TextStyle(fontSize: 16),
                readOnly: true, // Rendre les champs en lecture seule
              ),
            ),
          ],
        ),
      ),
    );
  }
}
