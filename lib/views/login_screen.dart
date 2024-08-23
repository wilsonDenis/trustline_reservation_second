import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/services/auth_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/views/admin/admin_dasboard.dart';
import 'package:trust_reservation_second/views/chauffeur/chauffeur_dashboard.dart';
import 'package:trust_reservation_second/views/hotel/hotel_dashboard.dart';
import 'package:trust_reservation_second/widgets/custom_text_form_field.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
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
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (formKey.currentState!.validate()) {
      final email = txtEmail.text;
      final password = txtPassword.text;
      final response = await AuthService().login({'email_ou_telephone': email, 'passCode': password});

      if (response.statusCode == 200) {
        final data = response.data;
        final userType = data['user_type'] ?? '';

        await LocalStorageService.saveData('user_id', data['user_id'] ?? -1);
        await LocalStorageService.saveData('user_type', data['user_type'] ?? '');
        await LocalStorageService.saveData('specific_id', data['specific_id'] ?? -1);
        await LocalStorageService.saveData('token', data['jwt'] ?? '');
        await LocalStorageService.saveData('refresh', data['refresh'] ?? '');

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => dashboard),
      );
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double containerWidth = width * 0.9;
    if (ResponsiveBreakpoints.of(context).largerThan(TABLET)) {
      containerWidth = width * 0.6;
    }
    if (ResponsiveBreakpoints.of(context).largerThan(DESKTOP)) {
      containerWidth = width * 0.4;
    }

    return Scaffold(
      backgroundColor: ColorsApp.beigeLightColor,
      body: Stack(
        children: <Widget>[
          Container(
            height: height * 0.59,
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
                  Icons.car_repair,
                  // Icons.send_and_archive_rounded,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  'NDJO-HOTEL',
                  style: TextStyle(
                    fontSize: 22,
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
                  child: Center(
                    child: Container(
                      width: containerWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.08, vertical: height * 0.04),
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.04),
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
                              child: Center(
                                child: Text(
                                  'Connexion',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            CustomTextFormField(
                              controller: txtEmail,
                              labelText: 'Email',
                              hintText: 'Entrez votre email',
                              keyboardType: TextInputType.emailAddress,
                              borderColor: Colors.grey,
                              borderWidth: 1.0,
                              validator: (value) =>
                                  value!.isEmpty ? 'Email requis' : null,
                              prefixIcon: Icons.mail,
                              obscureText: false,
                            ),
                            SizedBox(height: height * 0.02),
                            CustomTextFormField(
                              controller: txtPassword,
                              labelText: 'Mot de passe',
                              hintText: 'Entrez votre mot de passe',
                              keyboardType: TextInputType.visiblePassword,
                              borderColor: Colors.grey,
                              borderWidth: 1.0,
                              validator: (value) =>
                                  value!.isEmpty ? 'Mot de passe requis' : null,
                              prefixIcon: Icons.lock,
                              obscureText: true,
                            ),
                            SizedBox(height: height * 0.02),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/resetpasswordscreen');
                                },
                                child: const Text('Mot de passe oublié ?',
                                    style: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 26, 51),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                minimumSize: Size(double.infinity, height * 0.07),
                              ),
                              child: const Text('Se connecter',style: TextStyle( fontWeight: FontWeight.bold,fontSize: 17.5),),
                              
                            ),
                          ],
                        ),
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
