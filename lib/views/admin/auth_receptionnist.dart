import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/widgets/rectangle_button.dart';
import '../../widgets/code_input_field.dart';

class AuthReceptionnist extends StatefulWidget {
  const AuthReceptionnist({Key? key}) : super(key: key);

  @override
  _AuthReceptionnistState createState() => _AuthReceptionnistState();
}

class _AuthReceptionnistState extends State<AuthReceptionnist> {
  final int numberOfFields = 8; // Changez ce nombre pour augmenter ou diminuer le nombre de champs
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(numberOfFields, (_) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Authentication',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Pour plus de sécurité nous vous prions d'entrer le code de sécurité ",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: CodeInputField(
                    controllers: _controllers,
                    numberOfFields: numberOfFields,
                    fieldWidth: 65.0,
                    fieldHeight: 65.0,
                    borderRadius: 5.0,
                    backgroundColor: Colors.grey[200]!,
                    textStyle: const TextStyle(fontSize: 24.0),
                    fieldSpacing: 14.0,
                  ),
                ),
                const SizedBox(height: 40.0),
                RectangleButton(
                  onPressed: () => Navigator.pushNamed(context, '/createreservation'),
                  buttonText: "Done",
                  buttonColor: ColorsApp.primaryColor,
                  textColor: Colors.white,
                  buttonWidth: MediaQuery.of(context).size.width - 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
