import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/services/auth_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/views/admin/admin_dasboard.dart';
import 'package:trust_reservation_second/views/chauffeur/chauffeur_dashboard.dart';
import 'package:trust_reservation_second/views/hotel/hotel_dashboard.dart';
import 'package:trust_reservation_second/widgets/custom_text_form_field.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (formKey.currentState!.validate()) {
      final email = txtEmail.text;
      final password = txtPassword.text;
      final response = await AuthService().login({'email_ou_telephone': email, 'passCode': password});

      if (response.statusCode == 200) {
        final data = response.data; // Utilisation de response.data au lieu de response.body
        final userType = data['user_type'];
        await LocalStorageService.saveData('user_type', userType);

        switch (userType) {
          case 'administrateur':
            _navigateToDashboard(const AdminDashboard());
            break;
          case 'chauffeur':
            _navigateToDashboard(const ChauffeurDashboard());
            break;
          case 'hotel':
            _navigateToDashboard(const HotelDashboard());
            break;
          default:
            _showErrorSnackbar('Type d\'utilisateur non reconnu');
            break;
        }
      } else {
        _showErrorSnackbar('Échec de la connexion');
      }
    }
  }

  void _navigateToDashboard(Widget dashboard) {
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => dashboard));
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.beigeLightColor,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.67,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 26, 51),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.send_and_archive_rounded,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  'TrustLine',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Connexion',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            controller: txtEmail,
                            labelText: 'Email',
                            hintText: 'Entrez votre email',
                            keyboardType: TextInputType.emailAddress,
                            borderColor: Colors.grey,
                            borderWidth: 1.0,
                            validator: (value) => value!.isEmpty ? 'Email requis' : null,
                            prefixIcon: Icons.mail,
                            obscureText: false,
                          ),
                          const SizedBox(height: 15),
                          CustomTextFormField(
                            controller: txtPassword,
                            labelText: 'Mot de passe',
                            hintText: 'Entrez votre mot de passe',
                            keyboardType: TextInputType.visiblePassword,
                            borderColor: Colors.grey,
                            borderWidth: 1.0,
                            validator: (value) => value!.isEmpty ? 'Mot de passe requis' : null,
                            prefixIcon: Icons.lock,
                            obscureText: true,
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/registerscreen');
                              },
                              child: const Text('Mot de passe oublié ?', style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromARGB(255, 0, 26, 51),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Se connecter'),
                          ),
                        ],
                      ),
                    ),
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
