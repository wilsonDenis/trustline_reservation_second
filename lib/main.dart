import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:trust_reservation_second/models/notification_model.dart';
import 'package:trust_reservation_second/services/notification_service.dart';
import 'package:trust_reservation_second/views/admin/admin_auth.dart';
import 'package:trust_reservation_second/views/reset_password_screen.dart';
import 'package:trust_reservation_second/views/chauffeur/chauffeur_dashboard.dart';
import 'package:trust_reservation_second/views/hotel/add_receptionist_screen.dart';
import 'package:trust_reservation_second/views/hotel/create_reservation.dart';
import 'package:trust_reservation_second/views/hotel/hotel_dashboard.dart';
import 'package:trust_reservation_second/views/hotel/info_hotel_page.dart';
import 'package:trust_reservation_second/views/login_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:trust_reservation_second/views/splashscreen.dart';
import 'package:trust_reservation_second/views/hotel/configuration_hotel.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // Assurez-vous d'avoir importé ce fichier

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, 
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,  
  );

  await NotificationService.init();
  tz.initializeTimeZones();
  runApp(MultiProvider(
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
        scaffoldBackgroundColor: Colors.white,
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
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
        child: child!,
      ),
      home: const SplashScreen(),
      routes: {
        '/resetpasswordscreen': (context) => const ResetPasswordScreen(),
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
