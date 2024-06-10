import 'package:flutter/material.dart';
import 'package:trust_reservation_second/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreengState();
}

class _SplashScreengState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Naviguer automatiquement vers l'écran de connexion après quelques secondes
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 0, 26, 51),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.send_and_archive_rounded,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 20), // Ajoute un espace entre l'icône et le texte
              Text(
                'SeatSmart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
