import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40), // Added to provide some top space
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/icon_profile.png'), // Default profile image
            ),
            SizedBox(height: 8),
            Text(
              'Wils Dens',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Add your functionality here
                _showPhotoOptions(context);
              },
              child: Text(
                'Changer photo',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 16),
            _buildOption(context, 'Nom', Icons.person),
            _buildOption(context, 'Prénom', Icons.person_outline),
            _buildOption(context, 'Âge', Icons.cake),
            _buildOption(context, 'Numéro de téléphone', Icons.phone),
            _buildOption(context, 'Email', Icons.email),
            _buildOption(context, 'Changer mot de passe', Icons.lock),
            Spacer(),
            TextButton(
              onPressed: () {
                // Log out functionality
              },
              child: Text(
                'Fermer session',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Add navigation functionality
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
            Text(title),
          ],
        ),
      ),
    );
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
                backgroundImage: AssetImage('assets/icon_profile.png'), // Default profile image
              ),
              SizedBox(height: 8),
              Text(
                'Juan Lizcano',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Take photo functionality
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
                    // Choose from gallery functionality
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
}
