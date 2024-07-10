import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/widgets/rectangle_button.dart';

import '../../widgets/code_input_field.dart';

class GerantReceptAuth extends StatefulWidget {
  const GerantReceptAuth({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _GerantReceptAuthState createState() => _GerantReceptAuthState();
}

class _GerantReceptAuthState extends State<GerantReceptAuth> {
  final List<TextEditingController> _controllers =
      List.generate(8, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
            CodeInputField(
              controllers: _controllers,
              numberOfFields: 4,
              fieldWidth: 65.0,
              fieldHeight: 65.0,
              borderRadius: 5.0,
              backgroundColor: Colors.grey[200]!,
              textStyle: const TextStyle(fontSize: 24.0),
              fieldSpacing:
                  14.0, // Ajustez cette valeur pour réduire l'espacement
            ),
            const SizedBox(height: 10.0),
            const SizedBox(height: 40.0),
            RectangleButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/addreceptionistscreen'),
              buttonText: "Done",
              buttonColor: ColorsApp.primaryColor,
              textColor: Colors.white,
              buttonWidth: MediaQuery.of(context).size.width - 50,
            ),
          ],
        ),
      ),
    );
  }
}
