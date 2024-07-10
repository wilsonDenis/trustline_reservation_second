import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:trust_reservation_second/views/chauffeur/profile_screen.dart';
import 'package:trust_reservation_second/views/hotel/history_reservation.dart';
import 'package:trust_reservation_second/views/hotel/invoice_details_screen.dart';
import 'package:trust_reservation_second/widgets/custom_container.dart';
import 'package:trust_reservation_second/widgets/custom_container_large.dart';
import 'package:trust_reservation_second/views/hotel/hotel_notifications_page.dart';
import 'package:trust_reservation_second/services/auth_service.dart';
import 'package:trust_reservation_second/views/login_screen.dart';

class ChauffeurDashboard extends StatefulWidget {
  const ChauffeurDashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChauffeurDashboardState createState() => _ChauffeurDashboardState();
}

class _ChauffeurDashboardState extends State<ChauffeurDashboard> {
  // ignore: unused_field
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();

  // ignore: unused_element
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dashboardItems = [
      {
        'title': 'Profil',
        'count': 0, // Utilisez 0 pour la compatibilité
        'icon': Icons.person,
        'color': Colors.pink,
        'onTap': () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen())),
        'showIconInsteadOfCount': true, // Ajoutez cette ligne
      },
      {
        'title': 'Factures',
        'count': 298,
        'icon': Icons.receipt_long,
        'color': Colors.orange,
        'onTap': () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const InvoiceDetailsScreen())),
        'showIconInsteadOfCount': false, // Assurez-vous que cela est défini
      },
      {
        'title': 'Réservations',
        'count': 0,
        'icon': Icons.calendar_today,
        'color': Colors.blue,
        'onTap': () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HistoryReservations())),
        'showIconInsteadOfCount': false, // Assurez-vous que cela est défini
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            70.0), // Augmentez la hauteur pour donner plus d'espace
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: _logout, // Action pour le bouton de déconnexion
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trustline Driver',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  '1 juillet 2024',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            actions: [
              badges.Badge(
                showBadge: true,
                badgeContent:
                    const Text('5', style: TextStyle(color: Colors.white)),
                child: IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.grey),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HotelNotificationsPage()));
                  },
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CarouselSlider(
                options: CarouselOptions(
                  height: 230.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 6),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                ),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                          image: DecorationImage(
                            image: AssetImage('assets/carousel_image_$i.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomContainer(
                            icon: dashboardItems[0]['icon'],
                            title: dashboardItems[0]['title'],
                            count: dashboardItems[0]['count'],
                            color: dashboardItems[0]['color'],
                            onTap: dashboardItems[0]['onTap'],
                            showIconInsteadOfCount: dashboardItems[0][
                                'showIconInsteadOfCount'], // Ajoutez cette ligne
                            width: 180, // Spécifiez la largeur ici
                            height: 180, // Spécifiez la hauteur ici
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomContainer(
                            icon: dashboardItems[1]['icon'],
                            title: dashboardItems[1]['title'],
                            count: dashboardItems[1]['count'],
                            color: dashboardItems[1]['color'],
                            onTap: dashboardItems[1]['onTap'],
                            showIconInsteadOfCount: dashboardItems[1][
                                'showIconInsteadOfCount'], // Ajoutez cette ligne
                            width: 180, // Spécifiez la largeur ici
                            height:180, // Spécifiez la hauteur ici
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomContainerLarge(
                      icon: dashboardItems[2]['icon'],
                      title: dashboardItems[2]['title'],
                      count: dashboardItems[2]['count'],
                      color: dashboardItems[2]['color'],
                      onTap: dashboardItems[2]['onTap'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
