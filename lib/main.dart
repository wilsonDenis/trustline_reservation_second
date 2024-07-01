import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:trust_reservation_second/models/notification_model.dart';
import 'package:trust_reservation_second/services/notification_service.dart';
import 'package:trust_reservation_second/views/admin/admin_auth.dart';
import 'package:trust_reservation_second/views/auth_screen.dart';
import 'package:trust_reservation_second/views/chauffeur/chauffeur_dashboard.dart';
import 'package:trust_reservation_second/views/hotel/add_receptionist_screen.dart';
import 'package:trust_reservation_second/views/hotel/create_reservation.dart';
import 'package:trust_reservation_second/views/hotel/hotel_dashboard.dart';
import 'package:trust_reservation_second/views/hotel/info_hotel_page.dart';
import 'package:trust_reservation_second/views/login_screen.dart';
import 'package:trust_reservation_second/views/resset_password_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'views/hotel/configuration_hotel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  tz.initializeTimeZones();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationModel()),
      ],
      child: const MyApp(),
  
  ));
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      home: const ChauffeurDashboard(),
      // home: const SplashScreen(),
      // home: const HotelDashboard(),
      routes: {
        '/authscreen': (context) => const AuthScreen(),
        '/registerscreen': (context) => const ResetPasswordScreen(),
        '/loginscreen': (context) => const LoginScreen(),
        '/hoteldashboard': (context) => const HotelDashboard(),
        '/adminauth': (context) => const AdminAuth(),
        '/configurationhotel': (context) => const ConfigurationHotel(),
        '/addreceptionistscreen': (context) => const AddReceptionistScreen(),
        '/createreservation': (context) => const CreateReservation(),
        '/infohotel': (context) => const InfoHotel(),
        '/chauffeurdashboard': (context) => const ChauffeurDashboard(),

      },
    );
  }
}
