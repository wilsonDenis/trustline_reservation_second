import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/views/hotel/configuration_hotel.dart';
import 'package:trust_reservation_second/views/hotel/listes_receptionnists.dart';
import 'package:trust_reservation_second/widgets/rectangle_button.dart';

class InfoHotel extends StatelessWidget {
  const InfoHotel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset(
                'assets/hotel.jpg', // Utilisation de l'image depuis les assets
                height: MediaQuery.of(context).size.height /
                    2, // Moitié de la hauteur de l'écran
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: MediaQuery.of(context).size.height /
                    2, // Moitié de la hauteur de l'écran
                color: Colors.grey[300], // Couleur de fond gris clair
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 -
                50, // Position du premier container pour qu'il soit sur l'image
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // Bords arrondis
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Golden Ocean Hotel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColorsApp.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Al Meena St, Doha, Qatar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Located just 1 km from the corniche, the property offers a temperature controlled rooftop pool with amazing views of Doha skyline and the corniche. Free WiFi is available throughout the entire property.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 1),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height -
                250, // Position du deuxième container en bas, mais ne touche pas complètement le bas
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // Bords arrondis
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RectangleButton(
                        // onPressed : () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminAuth())),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ConfigurationHotel())),
                        buttonText: '',
                        buttonColor: ColorsApp.primaryColor,
                        textColor: Colors.white,
                        buttonWidth: MediaQuery.of(context).size.width / 3,
                        icon: Icons.settings,
                        iconColor: Colors.white,
                      ),
                      RectangleButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListesReceptionnists())),
                        buttonText: '',
                        buttonColor: ColorsApp.primaryColor,
                        textColor: Colors.white,
                        buttonWidth: MediaQuery.of(context).size.width / 3,
                        icon: Icons.info,
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
