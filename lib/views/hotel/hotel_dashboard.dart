import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/intl.dart';
import 'package:trust_reservation_second/services/user_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/views/admin/admin_auth.dart';
import 'package:trust_reservation_second/views/admin/auth_receptionnist.dart';
import 'package:trust_reservation_second/views/hotel/history_reservation.dart';
import 'package:trust_reservation_second/views/hotel/invoice_details_screen.dart';
import 'package:trust_reservation_second/views/login_screen.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/views/user_list_page.dart';
import '../../widgets/custom_container.dart';
import 'hotel_notifications_page.dart';

class HotelDashboard extends StatefulWidget {
  const HotelDashboard({super.key});

  @override
  _HotelDashboardState createState() => _HotelDashboardState();
}

class _HotelDashboardState extends State<HotelDashboard> {
  int _selectedIndex = 0;
  final UserService _userService = UserService();
  late Future<Map<String, dynamic>> _hotelInfo;

  @override
  void initState() {
    super.initState();
    _hotelInfo = _fetchHotelInfo();
  }

  Future<Map<String, dynamic>> _fetchHotelInfo() async {
    try {
      final specificId = await LocalStorageService.getData('specific_id');
      if (specificId == null) throw Exception('Specific ID not found');

      final response = await _userService.getHotelInfo(specificId);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load hotel info');
      }
    } catch (e) {
      throw Exception('Failed to load hotel info: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format de la date en 'fr_FR'
    final String todayDate = DateFormat.yMMMMEEEEd('fr_FR').format(DateTime.now());

    // Gestion de la navigation dynamique entre les pages
    Widget getSelectedPage() {
      switch (_selectedIndex) {
        case 0:
          return _buildHomePage(todayDate);
        case 1:
          return  UserListPage(); // Page pour la liste des utilisateurs
        default:
          return _buildHomePage(todayDate);
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _hotelInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final hotelInfo = snapshot.data!;
                return AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.power_settings_new_outlined, color: Colors.green, size: 30),
                    onPressed: _logout,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotelInfo['nom'] ?? 'Nom de l\'hôtel',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorsApp.primaryColor,
                        ),
                      ),
                      Text(
                        todayDate,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  actions: [
                    badges.Badge(
                      showBadge: true,
                      badgeContent: const Text('5', style: TextStyle(color: Colors.white)),
                      child: IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HotelNotificationsPage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                );
              } else {
                return const Center(child: Text('No data'));
              }
            },
          ),
        ),
      ),
      body: SafeArea(
        child: getSelectedPage(), // Affichage de la page sélectionnée
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey), // Icône de la page d'accueil
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.grey), // Icône des messages
            label: 'Messages',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 26, 51),
        onTap: _onItemTapped,
      ),
    );
  }

  // Méthode pour construire la page d'accueil
  Widget _buildHomePage(String todayDate) {
    final List<Map<String, dynamic>> dashboardItems = [
      {
        'title': 'Create Reservation',
        'count': 0,
        'icon': Icons.add,
        'color': Colors.pink,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AuthReceptionnist()),
        ),
      },
      {
        'title': 'Configuration',
        'count': 298,
        'icon': Icons.hotel_outlined,
        'color': Colors.orange,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminAuth()),
        ),
      },
      {
        'title': 'History Reservations',
        'count': 54,
        'icon': Icons.history_toggle_off,
        'color': Colors.blue,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryReservations()),
        ),
      },
      {
        'title': 'Invoices',
        'count': 48,
        'icon': Icons.inventory_outlined,
        'color': Colors.green,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InvoiceDetailsScreen()),
        ),
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          CarouselSlider(
            options: CarouselOptions(
              height: 250.0,
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
          const SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveBreakpoints.of(context).largerThan(TABLET) ? 64.0 : 16.0,
            ),
            child: ResponsiveGridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const ResponsiveGridDelegate(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 300,
              ),
              itemCount: dashboardItems.length,
              itemBuilder: (context, index) {
                final item = dashboardItems[index];
                return CustomContainer(
                  icon: item['icon'],
                  title: item['title'],
                  count: item['count'],
                  color: item['color'],
                  onTap: item['onTap'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
