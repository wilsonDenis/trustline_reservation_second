import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_reservation_second/services/user_service.dart';


final UserService _userService = UserService();

Future<void> loadAddresses(TextEditingController addressController) async {
  final prefs = await SharedPreferences.getInstance();
  addressController.text = prefs.getString('default_address') ?? 'Adresse de départ';
}

Future<void> getCurrentLocation(TextEditingController addressController) async {
  // Simule l'obtention de l'adresse actuelle de l'hôtel
  const currentAddress = 'Adresse actuelle de l\'hôtel'; // Remplacez par l'appel à votre service de localisation réel
  addressController.text = currentAddress;
}

void swapAddress(bool isDefaultAddress, TextEditingController addressController, TextEditingController destinationController, Function calculateEstimation) {
  isDefaultAddress = !isDefaultAddress;
  addressController.text = isDefaultAddress ? 'Adresse de départ' : '';
  destinationController.text = isDefaultAddress ? '' : 'Adresse de destination';
  calculateEstimation();
}

Future<void> selectDate(BuildContext context, DateTime? selectedDate, Function(DateTime) onDatePicked, Function calculateEstimation) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2101),
    locale: const Locale('fr', 'FR'),
  );
  if (pickedDate != null && pickedDate != selectedDate) {
    onDatePicked(pickedDate);
    calculateEstimation();
  }
}

Future<void> selectTime(BuildContext context, TimeOfDay? selectedTime, Function(TimeOfDay) onTimePicked, Function calculateEstimation) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (pickedTime != null && pickedTime != selectedTime) {
    onTimePicked(pickedTime);
    calculateEstimation();
  }
}

Future<void> calculateEstimation({
  required DateTime? selectedDate,
  required TimeOfDay? selectedTime,
  required TextEditingController addressController,
  required TextEditingController destinationController,
  required Function(String, String, String) onEstimationReceived,
}) async {
  if (selectedDate != null &&
      selectedTime != null &&
      addressController.text.isNotEmpty &&
      destinationController.text.isNotEmpty) {
    String datePriseEnChargeISO = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    ).toIso8601String();

    final formData = {
      'datePriseEnCharge': datePriseEnChargeISO,
      'departAddress': addressController.text,
      'destinationAddress': destinationController.text,
    };

    try {
      final response = await _userService.calculateDistance(formData);
      if (response.statusCode == 200) {
        onEstimationReceived(
          response.data['distParcourt'].toString(),
          response.data['durParcourt'].toString(),
          response.data['transport_estimates'][0]['cout'].toString(),
        );
      } else {
        // Gérer l'erreur en conséquence
      }
    } catch (e) {
      // Gérer l'exception en conséquence
    }
  }
}

Future<void> saveDataToSharedPreferences(Map<String, String> data) async {
  final prefs = await SharedPreferences.getInstance();
  data.forEach((key, value) async {
    await prefs.setString(key, value);
  });
}

Future<void> clearSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
