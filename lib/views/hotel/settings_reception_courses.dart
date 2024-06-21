import 'package:flutter/material.dart';
import 'package:trust_reservation_second/widgets/custom_icon_button.dart';

class ReceptionCoursesPage extends StatelessWidget {
  const ReceptionCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receptionists and Courses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomIconButton(
                    icon: Icons.person_pin,
                    label: 'Receptionists Lists ',
                    color: const Color.fromARGB(255, 243, 86, 33),
                    onPressed: () {
                      // Action spécifique ou navigation
                      Navigator.pushNamed(context, '/receptionists');
                    },
                  ),
                  const SizedBox(height: 10.0),
                  CustomIconButton(
                    icon: Icons.task_alt,
                    label: 'Courses',
                    color: const Color.fromARGB(255, 96, 76, 175),
                    onPressed: () {
                      // Action spécifique ou navigation
                      Navigator.pushNamed(context, '/courses');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
