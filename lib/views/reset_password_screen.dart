import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/widgets/custom_text_form_field.dart';
import 'package:trust_reservation_second/widgets/rectangle_button.dart';
import 'package:trust_reservation_second/services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtVerificationCode = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtConfirmPassword = TextEditingController();
  final AuthService _authService = AuthService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool isVerificationStep = true;

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

  Future<void> _requestVerificationCode() async {
    if (txtEmail.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email requis')),
      );
      return;
    }

    try {
      final response = await _authService.passwordResetRequest(txtEmail.text);

      if (response != null && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Code de vérification envoyé avec succès')),
        );
        setState(() {
          isVerificationStep = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response?.data['error'] ?? 'Erreur inconnue'}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion: $e')),
      );
    }
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      if (txtPassword.text != txtConfirmPassword.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Les mots de passe ne correspondent pas.')),
        );
        return;
      }

      try {
        final response = await _authService.resetPassword(
          txtEmail.text,
          txtVerificationCode.text,
          txtPassword.text,
          txtConfirmPassword.text,
        );

        if (response != null && response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mot de passe mis à jour avec succès')),
          );
          Navigator.of(context).pushReplacementNamed('/loginscreen');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${response?.data['error'] ?? 'Erreur inconnue'}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion: $e')),
        );
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
              height: MediaQuery.of(context).size.height * 0.43,
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
                          if (isVerificationStep)
                            CustomTextFormField(
                              labelText: 'Adresse Email',
                              hintText: 'Entrez votre email',
                              prefixIcon: Icons.email,
                              validator: (value) => value!.isEmpty ? 'Email requis' : null,
                              controller: txtEmail,
                              obscureText: false,
                            )
                          else ...[
                            CustomTextFormField(
                              labelText: 'Code de Vérification',
                              hintText: 'Entrez le code de vérification',
                              prefixIcon: Icons.vpn_key,
                              validator: (value) =>
                                  value!.isEmpty ? 'Code de vérification requis' : null,
                              controller: txtVerificationCode,
                              obscureText: false,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              labelText: 'Nouveau mot de passe',
                              hintText: 'Entrez votre nouveau mot de passe',
                              prefixIcon: Icons.lock,
                              validator: (value) =>
                                  value!.isEmpty ? 'Mot de passe requis' : null,
                              controller: txtPassword,
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              labelText: 'Confirmer le mot de passe',
                              hintText: 'Confirmez votre nouveau mot de passe',
                              prefixIcon: Icons.lock,
                              validator: (value) =>
                                  value!.isEmpty ? 'Confirmation requise' : null,
                              controller: txtConfirmPassword,
                              obscureText: true,
                            ),
                          ],
                          const SizedBox(height: 20),
                          RectangleButton(
                            buttonText: isVerificationStep
                                ? "Envoyer le Code de Vérification"
                                : "Réinitialiser le mot de passe",
                            buttonColor: ColorsApp.primaryColor,
                            textColor: Colors.white,
                            onPressed: isVerificationStep ? _requestVerificationCode : _resetPassword,
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
