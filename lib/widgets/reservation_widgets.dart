import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/services/location_service.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';

Widget buildVehicleSelectionStep(
  List<dynamic> vehicles,
  Function(String) onVehicleSelected,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Center(
        child: Text(
          'Choisir un véhicule',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 16),
      ...vehicles.map((vehicle) {
        return buildVehicleOption(
          vehicle['typeVehicule'],
          vehicle['capacite_passagers'].toString(),
          vehicle['capacite_chargement'],
          vehicle['type_carburant'],
          vehicle['cout'].toString(),
          vehicle['galerie'],
          onVehicleSelected,
        );
      }).toList(),
    ],
  );
}

Widget buildVehicleOption(
  String type,
  String seats,
  String trunk,
  String fuel,
  String price,
  String imagePath,
  Function(String) onVehicleSelected,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Image.network(imagePath, height: 200, fit: BoxFit.cover),
        const SizedBox(height: 16),
        Text(
          type,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Type: $type | Pass: $seats | Bags: $trunk'),
        Text('Fuel: $fuel'),
        Text('Price: $price€'),
        const SizedBox(height: 8),
        CustomButton(
          onPressed: () {
            onVehicleSelected(type);
          },
          text: 'Choisir',
          backgroundColor: Colors.orange,
        ),
      ],
    ),
  );
}

Widget buildDateTimeSelectionStep(
  BuildContext context,
  DateTime? selectedDate,
  TimeOfDay? selectedTime,
  TextEditingController addressController,
  TextEditingController destinationController,
  bool isDefaultAddress,
  String estimation,
  String distParcourt,
  String durParcourt,
  Function(DateTime) onDateSelected,
  Function(TimeOfDay) onTimeSelected,
  Function onAddressSelected,
  Function onDestinationSelected,
  Function swapAddress,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onDateSelected(selectedDate!),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date', style: TextStyle(color: Colors.grey)),
                    Text(
                      selectedDate != null
                          ? DateFormat.yMMMMd('fr_FR').format(selectedDate)
                          : 'date',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => onTimeSelected(selectedTime!),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Heure', style: TextStyle(color: Colors.grey)),
                    Text(
                      selectedTime != null ? selectedTime.format(context) : 'heure',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Autocomplete<Place>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<Place>.empty();
                          }
                          return LocationService.getSuggestions(textEditingValue.text)
                              .then((suggestions) => suggestions);
                        },
                        displayStringForOption: (Place option) => option.description,
                        onSelected: (Place selection) {
                          addressController.text = selection.description;
                          onAddressSelected();
                        },
                        fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted,
                        ) {
                          return TextFormField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            onFieldSubmitted: (String value) {
                              onFieldSubmitted();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Adresse de départ',
                              border: InputBorder.none,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              icon: const Icon(Icons.swap_horiz, color: ColorsApp.primaryColor),
              onPressed: () => swapAddress(),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      if (!isDefaultAddress) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.69,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Autocomplete<Place>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<Place>.empty();
                      }
                      return LocationService.getSuggestions(textEditingValue.text)
                          .then((suggestions) => suggestions);
                    },
                    displayStringForOption: (Place option) => option.description,
                    onSelected: (Place selection) {
                      destinationController.text = selection.description;
                      onDestinationSelected();
                    },
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      return TextFormField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        onFieldSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Adresse de destination',
                          border: InputBorder.none,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.69,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$$estimation',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$distParcourt km',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$durParcourt',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ],
  );
}
