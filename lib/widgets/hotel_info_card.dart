import 'package:flutter/material.dart';

class HotelInfoCard extends StatelessWidget {
  final String? logoUrl;
  final Map<String, dynamic> hotelData;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  HotelInfoCard({this.logoUrl, required this.hotelData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (logoUrl != null)
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.network(
                    logoUrl!,
                    height: 100.0,
                  ),
                ),
              ),
            Text(
              'Hotel Name: ${hotelData['name']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Email: ${hotelData['email']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Phone: ${hotelData['phone']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Website: ${hotelData['website']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Address: ${hotelData['address']}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
