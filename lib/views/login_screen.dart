import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
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
                  'SeatSmart',
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
                            'connexion',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 1),
                        // Text(
                        //   'Welcome back, login to continue enjoy professional services at a lower cost.',
                        //   textAlign: TextAlign.left,
                        //   style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        // ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: txtEmail,
                          labelText: 'email',
                          hintText: 'entre ton email',
                          keyboardType: TextInputType.emailAddress,
                          borderColor: Colors.grey,
                          borderWidth: 1.0,
                          validator: (value) =>
                              value!.isEmpty ? 'Email requis' : null,
                          prefixIcon: Icons.mail,
                          showSuffixIcon: false,
                        ),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                          controller: txtPassword,
                          labelText: 'Mot de passe',
                          hintText: 'Entrez votre mot de passe',
                          keyboardType: TextInputType.visiblePassword,
                          borderColor: Colors.grey,
                          borderWidth: 1.0,
                          validator: (value) =>
                              value!.isEmpty ? 'Password requis' : null,
                          prefixIcon: Icons.lock,
                          showSuffixIcon: true,
                        ),
                        const SizedBox(height: 1),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {Navigator.pushNamed(context,'/registerscreen');},
                            child: const Text('mot de passe oublié ?',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(height: 5),
                       
                    ElevatedButton(
                    onPressed: () {
                      // Navigator.pushNamed(context,'/Homescreen');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 0, 26, 51),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(' Se connecter '),
                  ),
                      
                      ],
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
