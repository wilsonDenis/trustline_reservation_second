import 'package:flutter/material.dart';
import 'package:trust_reservation_second/views/auth_screen.dart';
import 'package:trust_reservation_second/views/splashscreen.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:trust_reservation_second/views/login_screen.dart';
import 'package:trust_reservation_second/views/resset_password_screen.dart';

void main() {
  runApp(const MyApp());
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      )
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Management',
      theme: ThemeData(
        primarySwatch: Colors.orange,
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
