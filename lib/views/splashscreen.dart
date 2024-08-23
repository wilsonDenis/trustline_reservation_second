import 'package:flutter/material.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/views/admin/admin_dasboard.dart';
import 'package:trust_reservation_second/views/chauffeur/chauffeur_dashboard.dart';
import 'package:trust_reservation_second/views/hotel/hotel_dashboard.dart';
import 'package:trust_reservation_second/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final userType = await LocalStorageService.getData('user_type');

    if (userType != null) {
      if (userType == 'administrateur') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else if (userType == 'chauffeur') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ChauffeurDashboard()),
        );
      } else if (userType == 'hotel') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HotelDashboard()),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
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
              SizedBox(height: 20),
              Text(
                'TrustLine',
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
