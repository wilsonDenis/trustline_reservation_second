import 'package:flutter/material.dart';
import 'package:trust_reservation_second/views/loading.dart';
import 'package:trust_reservation_second/views/login_page2.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

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
      ),
      home:  const  Loading(),
      routes:{
        '/loginpage':(context)=>const LoginPage(),
      }
    );
  }
}
