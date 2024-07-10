import 'dart:ui';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';

class ReservationDetailsScreen extends StatelessWidget {
  final Map<String, String> reservation;

  const ReservationDetailsScreen({super.key, required this.reservation});

  static const Color primaryColor = Color.fromARGB(255, 0, 26, 51);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<AnimatedFloatingActionButtonState> fabKey =
        GlobalKey<AnimatedFloatingActionButtonState>();

    Widget editButton() {
      return FloatingActionButton(
        onPressed: () {
          // Handle modification
        },
        heroTag: "edit",
        tooltip: 'Edit',
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: ColorsApp.primaryColor,
      );
    }

    Widget deleteButton() {
      return FloatingActionButton(
        onPressed: () {
          // Handle deletion
        },
        heroTag: "delete",
        tooltip: 'Delete',
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        backgroundColor: ColorsApp.primaryColor,
      );
    }

    Widget shareButton() {
      return FloatingActionButton(
        onPressed: () {
          // Handle sharing
        },
        heroTag: "share",
        tooltip: 'Share',
        child: Icon(Icons.share, color: Colors.white),
        backgroundColor: ColorsApp.primaryColor,
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(226, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Reservation Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ma Reservation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  // Text(
                  //   'A4-123',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 40.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DPS',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Bali',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Text(
                          'Flight Time\n1h 45m',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'CGK',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Banten',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('10:00 ', style: TextStyle(fontSize: 18)),
                        Icon(Icons.drive_eta_rounded, color: primaryColor),
                        Text('11:45 ', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Passenger Name',
                            style: TextStyle(color: Colors.grey)),
                        Text('Flight Date',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Wilson Denis', style: TextStyle(fontSize: 18)),
                        Text('25 Dec 2024', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Terminal', style: TextStyle(color: Colors.grey)),
                        Text('Seat', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('4', style: TextStyle(fontSize: 18)),
                        Text('B4', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gate', style: TextStyle(color: Colors.grey)),
                        Text('Class', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('A4', style: TextStyle(fontSize: 18)),
                        Text('Business', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        fabButtons: <Widget>[
          editButton(),
          deleteButton(),
          shareButton(),
        ],
        key: fabKey,
        colorStartAnimation: Colors.white,
        colorEndAnimation: Colors.white,
        animatedIconData: AnimatedIcons.menu_close,
      ),
    );
  }
}

// class CustomIconButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final IconData icon;

//   const CustomIconButton({
//     Key? key,
//     required this.onPressed,
//     required this.icon,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: ColorsApp.primaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         padding: const EdgeInsets.all(16.0),
//       ),
//       child: Icon(
//         icon,
//         color: Colors.white,
//       ),
//     );
//   }
// }
