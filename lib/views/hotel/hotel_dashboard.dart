// hotel_dashboard.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:trust_reservation_second/views/admin/auth_receptionnist.dart';
import 'package:trust_reservation_second/views/hotel/create_reservation.dart';
import 'package:trust_reservation_second/views/hotel/history_reservation.dart';
import 'package:trust_reservation_second/views/hotel/info_hotel_page.dart';
import 'package:trust_reservation_second/views/hotel/invoice_details_screen.dart';
import 'package:trust_reservation_second/widgets/custom_container.dart';
import 'package:trust_reservation_second/views/hotel/hotel_notifications_page.dart';


class HotelDashboard extends StatefulWidget {
  const HotelDashboard({super.key});

  @override
  _HotelDashboardState createState() => _HotelDashboardState();
}

class _HotelDashboardState extends State<HotelDashboard> {
  int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dashboardItems = [
      {
        'title': 'Create Reservation',
        'count': 0,
        'icon': Icons.add,
        'color': Colors.pink,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthReceptionnist())),

      },
      {
        'title': 'Confiugration',
        'count': 298,
        'icon': Icons.hotel_outlined,
        'color': Colors.orange,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoHotel())),
        // 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryReservations())),
      },
      {
        'title': 'History Reservations',
        'count': 54,
        'icon': Icons.history_toggle_off,
        'color': Colors.blue,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryReservations())),

      },
      {
        'title': 'Invoices',
        'count': 48,
        'icon': Icons.inventory_outlined,
        'color': Colors.green,//InvoiceDetailsScreen
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InvoiceDetailsScreen())),


      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // Increase the height to give more space
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                // Action for menu button
              },
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Denis wilson',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  'Tue, 05 Dec',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HotelNotificationsPage()));
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
                  height: 200.0,
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
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
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.grey),
            label: 'Reservations',
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.grey),
            label: 'Messages',
          ),
         
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:  const Color.fromARGB(255, 0, 26, 51),
        onTap: _onItemTapped,
      ),
    );
  }
}
