import 'package:flutter/material.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';

import '../../services/api_service.dart';

class VoitureChoice extends StatelessWidget {
  final Function(String) onCarSelected;

  const VoitureChoice({Key? key, required this.onCarSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir un véhicule'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erreur lors du chargement des véhicules.'));
          } else {
            final vehicles = snapshot.data!;
            return ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return _buildVehicleOption(
                  vehicle['typeVehicule'],
                  vehicle['capacite_passagers'].toString(),
                  vehicle['capacite_chargement'],
                  vehicle['type_carburant'],
                  vehicle['coutBrute'].toString(),
                  vehicle['galerie'],
                  context,
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchVehicles() async {
    final response = await ApiService().getData('/gve/vehicules/');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Widget _buildVehicleOption(
    String type,
    String seats,
    String trunk,
    String fuel,
    String price,
    String imagePath,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Image.network(imagePath, width: 100, height: 100), // Utilisation d'images réseau
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type de véhicule: $type', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Sièges: $seats'),
                Text('Coffre: $trunk'),
                Text('Carburant: $fuel'),
                Text('Prix: $price'),
                const SizedBox(height: 8),
                CustomButton(
                  onPressed: () {
                    onCarSelected(type);
                    Navigator.pop(context);
                  },
                  text: 'Choisir',
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// class VoitureChoice extends StatelessWidget {
//   final Function(String) onCarSelected;

//   const VoitureChoice({Key? key, required this.onCarSelected})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<String> carImages = [
//       'assets/corolla.png',
//       'assets/fortuner.png',
//       'assets/mercedese.png',
//       'assets/santafe.png',
//       'assets/tesla.png',
//       'assets/nissanpngwing.png',
//       'assets/tucson.png'
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choisir une Voiture'),
//       ),
//       body: GridView.builder(
//         padding: const EdgeInsets.all(16.0),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16.0,
//           mainAxisSpacing: 16.0,
//         ),
//         itemCount: carImages.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () {
//               onCarSelected(carImages[index]);
//             },
//             child: Card(
//               elevation: 6.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Image.asset(carImages[index], fit: BoxFit.cover),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text('Car Model',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   const Text('Price: \$50'),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
