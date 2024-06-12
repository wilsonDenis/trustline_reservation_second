import 'package:flutter/material.dart';
import 'package:trust_reservation_second/views/hotel/current_reservation.dart';
import 'package:trust_reservation_second/views/hotel/hotel_notifications_page.dart';
import 'package:trust_reservation_second/views/hotel/resevation_details.dart';
import 'package:trust_reservation_second/views/hotel/create_reservation.dart';
import 'package:trust_reservation_second/views/hotel/edit_reservation.dart';
import 'package:trust_reservation_second/views/hotel/reservation_history.dart';
import 'package:trust_reservation_second/views/hotel/hotel_profile.dart';
import 'package:trust_reservation_second/views/hotel/account_settings.dart';
import 'package:trust_reservation_second/views/hotel/messaging.dart';


class HotelDashboard extends StatelessWidget {
  const HotelDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dashboardItems = [
      {
        'title': 'Create Reservation',
        'icon': Icons.add,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateReservation())),
      },
      {
        'title': 'Edit Reservation',
        'icon': Icons.edit,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditReservation())),
      },
      {
        'title': 'Reservation Details',
        'icon': Icons.details,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationDetails())),
      },
      {
        'title': 'Reservation History',
        'icon': Icons.history,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReservationHistory())),
      },
      {
        'title': 'Current Reservations',
        'icon': Icons.list,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CurrentReservations())),
      },
      {
        'title': 'Hotel Profile',
        'icon': Icons.person,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HotelProfile())),
      },
      {
        'title': 'Account Settings',
        'icon': Icons.settings,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettings())),
      },
      {
        'title': 'Messaging',
        'icon': Icons.message,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Messaging())),
        'badge': 'messageCount',
      },
      {
        'title': 'Notifications',
        'icon': Icons.notifications,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HotelNotificationsPage())),
        'badge': 'notificationCount',
      },
    ];

    return Scaffold(
    
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              GridView.builder(
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
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: item['onTap'],
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Consumer<NotificationModel>(
                            //   builder: (context, model, child) {
                            //     return Badge(
                            //       showBadge: item.containsKey('badge') &&
                            //           ((item['badge'] == 'notificationCount' && model.notificationCount > 0) ||
                            //               (item['badge'] == 'messageCount' && model.messageCount > 0)),
                            //       badgeContent: Text(
                            //         item['badge'] == 'notificationCount'
                            //             ? model.notificationCount.toString()
                            //             : model.messageCount.toString(),
                            //         style: const TextStyle(color: Colors.white),
                            //       ),
                            //       child: Icon(item['icon'], size: 40, color: Colors.grey[700]),
                            //     );
                            //   },
                            // ),
                            const SizedBox(height: 10),
                            Text(
                              item['title'],
                              style: const TextStyle(
                                // color: Colors.grey[00],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
