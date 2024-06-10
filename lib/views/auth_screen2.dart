// import 'package:flutter/material.dart';

// class AuthScreen extends StatelessWidget {
//   const AuthScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: <Widget>[
//           Container(
//             height: MediaQuery.of(context).size.height * 0.67,
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               color: Color.fromARGB(255, 0, 26, 51),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(15),
//                 bottomRight: Radius.circular(15),
//               ),
//             ),
//             child: const Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Icon(
//                   Icons.accessible_forward,
//                   size: 100,
//                   color: Colors.white,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'SeatSmart',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
//               margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10,
//                     offset: Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor: const Color.fromARGB(255, 0, 26, 51),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5.0),
//                       ),
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     child: const Text('Create Account'),
//                   ),
//                   const SizedBox(height: 5),
//                   const Row( mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width:
//                             50, // Ajustez cette valeur pour la largeur souhaitée
//                         child: Divider(
//                           color: Color.fromARGB(87, 0, 0, 0),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: Text(
//                           'or',
//                           style: TextStyle(color: Color.fromARGB(219, 0, 0, 0)),
//                         ),
//                       ),
//                       SizedBox(
//                         width:
//                             50, // Ajustez cette valeur pour la largeur souhaitée
//                         child: Divider(
//                           color: Color.fromARGB(87, 0, 0, 0),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   OutlinedButton(
//                     onPressed: () {},
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: const Color.fromARGB(255, 0, 26, 51),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5.0),
//                       ),
//                       minimumSize: const Size(double.infinity, 50),
//                       side: const BorderSide(color: Color.fromARGB(255, 0, 26, 51),),
//                     ),
//                     child: const Text('Login'),
//                   ),
//                   const SizedBox(height: 10),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
