import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/widgets/custom_text_form_field.dart';
import 'package:trust_reservation_second/widgets/rectangle_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (txtPassword.text != txtConfirmPassword.text) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Passwords do not match.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Simuler l'appel API ici
        try {
          // Simulation d'un appel API
          await Future.delayed(const Duration(seconds: 2));
          // Si tout se passe bien, vous pouvez afficher un message de succès ou rediriger l'utilisateur
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Password has been successfully reset.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } catch (e) {
          // Gérer l'erreur de l'API ici
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('An error occurred: $e'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.beigeLightColor,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 26, 51),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 40,
                        offset: Offset(1, 10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                            prefixIcon: Icons.email,
                            validator: (value) =>
                                value!.isEmpty ? 'Email is required' : null,
                            controller: txtEmail,
                            readOnly: true, // Transformer en champ de lecture seule
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            labelText: 'New Password',
                            hintText: 'Enter your new password',
                            prefixIcon: Icons.lock,
                            showSuffixIcon: true,
                            validator: (value) =>
                                value!.isEmpty ? 'Password is required' : null,
                            controller: txtPassword,
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            labelText: 'Confirm Password',
                            hintText: 'Confirm your new password',
                            prefixIcon: Icons.lock,
                            showSuffixIcon: true,
                            validator: (value) =>
                                value!.isEmpty ? 'Password confirmation is required' : null,
                            controller: txtConfirmPassword,
                          ),
                          const SizedBox(height: 20),
                          RectangleButton(
                            buttonText: "Reset Password",
                            buttonColor: ColorsApp.primaryColor,
                            textColor: Colors.white,
                            onPressed: _submit,
                            buttonWidth: MediaQuery.of(context).size.width - 50,
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
