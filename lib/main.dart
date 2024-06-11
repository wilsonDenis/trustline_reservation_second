import 'package:flutter/material.dart';
import 'package:trust_reservation_second/services/notification_service.dart';
import 'package:trust_reservation_second/views/auth_screen.dart';
import 'package:trust_reservation_second/views/splashscreen.dart';

import 'package:trust_reservation_second/views/login_screen.dart';
import 'package:trust_reservation_second/views/resset_password_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.initialize();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),

      ),
      home:  const SplashScreen(),
      routes:{
        '/authscreen':(context)=>const AuthScreen(),
        '/registerscreen':(context)=>const ResetPasswordScreen(),
        '/loginscreen':(context)=>const LoginScreen(),
      }
    );
  }
}
