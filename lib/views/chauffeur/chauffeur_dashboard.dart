import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:dio/dio.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trust_reservation_second/services/user_service.dart';
import 'package:trust_reservation_second/services/chauffeur_service.dart';
import 'package:trust_reservation_second/views/chauffeur/profile_screen.dart';
import 'package:trust_reservation_second/views/hotel/hotel_notifications_page.dart';
import 'package:trust_reservation_second/services/api_service.dart'; // Import du ApiService

class ChauffeurDashboard extends StatefulWidget {
  const ChauffeurDashboard({super.key});

  @override
  _ChauffeurDashboardState createState() => _ChauffeurDashboardState();
}

class _ChauffeurDashboardState extends State<ChauffeurDashboard> {
  int _selectedIndex = 0;
  final UserService _userService = UserService();
  final ChauffeurService _chauffeurService = ChauffeurService();
  final ApiService _apiService = ApiService(); // Création d'une instance d'ApiService
  Future<Response>? _chauffeurData;
  Future<Response>? _todayTrip;
  Future<Response>? _rating;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final userInfo = await _userService.getUserInfo();
    setState(() {
      _userId = userInfo['userId'];
      if (_userId != null) {
        _chauffeurData = _chauffeurService.getChauffeurInfo();
        _todayTrip = _chauffeurService.getTodayTrip(_userId!);
        _rating = _chauffeurService.getRating(_userId!);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        
        backgroundColor: Colors.black,
        elevation: 0,
        title: FutureBuilder<Response>(
          future: _chauffeurData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  children: [
                    const CircleAvatar(radius: 20, backgroundColor: Colors.white),
                    const SizedBox(width: 10),
                    Container(
                      width: 80,
                      height: 5,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Erreur', style: TextStyle(color: Colors.white));
            } else if (snapshot.hasData && snapshot.data!.data != null) {
              var data = snapshot.data!.data;
              String photoUrl = '${_apiService.baseUrl.replaceAll('/api', '')}${data['photo']}'; // Construction de l'URL dynamique

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(photoUrl), // Utilisation de l'URL dynamique
                    ),
                    const SizedBox(width: 40),
                    Flexible(
                      child: Text(
                        'Bonjour, ${data['first_name']} ${data['last_name']}',
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Text('Aucune donnée', style: TextStyle(color: Colors.white));
            }
          },
        ),
        actions: [
          badges.Badge(
            showBadge: true,
            badgeContent: const Text('5', style: TextStyle(color: Colors.white)),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HotelNotificationsPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondblanc.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildOverviewPage(),
                _buildOffersPage(),
                _buildPlannedPage(),
                _buildFinishedPage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:const  Color.fromARGB(241, 0, 0, 0),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Aperçu',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.local_offer, color: Colors.black),
          //   label: 'Offres',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, color: Colors.white),
            label: 'Planifié',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.white),
            label: 'message',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildOverviewPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTodayTripSection(),
            const SizedBox(height: 16),
            _buildRatingSection(),
            const SizedBox(height: 16),
            _buildNewsAndUpdatesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersPage() {
    return const Center(
      child: Text('Offres Page'),
    );
  }

  Widget _buildPlannedPage() {
    return const Center(
      child: Text('Planifié Page'),
    );
  }

  Widget _buildFinishedPage() {
    return const Center(
      child: Text('Terminé Page'),
    );
  }

  Widget _buildTodayTripSection() {
    return FutureBuilder<Response>(
      future: _todayTrip,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Chargement...', style: TextStyle(color: Colors.black));
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aujourd\'hui, 14:45',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'Holcim Innovation Center, Rue du Montmurier 95,...',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'INVITÉ',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Mr Christophe Clemente',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.data != null) {
          var data = snapshot.data!.data;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aujourd\'hui, ${data['time']}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  '${data['location']}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'INVITÉ',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  '${data['guest']}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        } else {
          return const Text('Aucune donnée', style: TextStyle(color: Colors.black));
        }
      },
    );
  }

  Widget _buildRatingSection() {
    return FutureBuilder<Response>(
      future: _rating,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Chargement...', style: TextStyle(color: Colors.black));
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Évaluation',
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    Text(
                      '4.00',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(Icons.star, color: Colors.yellow),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.data != null) {
          var data = snapshot.data!.data;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Évaluation',
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    Text(
                      '${data['rating']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(Icons.star, color: Colors.yellow),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Text('Aucune donnée', style: TextStyle(color: Colors.black));
        }
      },
    );
  }

  Widget _buildNewsAndUpdatesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Nouvelles et mises à jour',
            style: TextStyle(color: Colors.white),
          ),
          Icon(Icons.arrow_forward, color: Colors.orange),
        ],
      ),
    );
  }
}
