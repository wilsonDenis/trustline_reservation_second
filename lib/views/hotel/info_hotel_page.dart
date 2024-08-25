import 'package:flutter/material.dart';
import 'package:trust_reservation_second/services/user_service.dart';
import 'package:trust_reservation_second/views/hotel/configuration_hotel.dart';
import 'package:trust_reservation_second/views/hotel/listes_receptionnistes_screen.dart';
import 'package:trust_reservation_second/widgets/rectangle_button.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';

class InfoHotel extends StatefulWidget {
  const InfoHotel({super.key});

  @override
  _InfoHotelState createState() => _InfoHotelState();
}

class _InfoHotelState extends State<InfoHotel> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _hotelInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final hotelInfo = snapshot.data!;
            final String? hotelImageUrl = hotelInfo['photo'];
            const String placeholderImagePath = 'assets/hotel.jpg';

            return Stack(
              children: [
                Column(
                  children: [
                    hotelImageUrl != null && hotelImageUrl.isNotEmpty
                        ? Image.network(
                            'http://192.168.1.66:8081$hotelImageUrl',
                          
                            height: MediaQuery.of(context).size.height / 2,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                placeholderImagePath,
                                height: MediaQuery.of(context).size.height / 2,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            placeholderImagePath,
                            height: MediaQuery.of(context).size.height / 2,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 2 - 70,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
                      children: [
                        Text(
                          hotelInfo['nom'] ?? 'Nom de l\'hôtel',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ColorsApp.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hotelInfo['adresse'] ?? 'Adresse de l\'hôtel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hotelInfo['description'] ?? 'Description de l\'hôtel',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: ${hotelInfo['email'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Téléphone: ${hotelInfo['telephone'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Site Web: ${hotelInfo['site_web'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Evaluation: 5.0',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height - 241,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RectangleButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ConfigurationHotel())),
                              buttonText: '',
                              buttonColor: ColorsApp.primaryColor,
                              textColor: Colors.white,
                              buttonWidth:
                                  MediaQuery.of(context).size.width / 3,
                              icon: Icons.settings,
                              iconColor: Colors.white,
                            ),
                            RectangleButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                         const ListReceptionnistesScreen())),
                              buttonText: '',
                              buttonColor: ColorsApp.primaryColor,
                              textColor: Colors.white,
                              buttonWidth:
                                  MediaQuery.of(context).size.width / 3,
                              icon: Icons.info,
                              iconColor: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
