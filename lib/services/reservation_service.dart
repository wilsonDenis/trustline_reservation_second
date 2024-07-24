import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/services/user_service.dart';
import 'package:trust_reservation_second/services/api_service.dart';

class ReservationService {
  final UserService _userService = UserService();
  final ApiService _apiService = ApiService();

  Future<void> loadAddresses(TextEditingController addressController) async {
    final prefs = await SharedPreferences.getInstance();
    addressController.text = prefs.getString('default_address') ?? 'Adresse de départ';
  }

  Future<void> getCurrentLocation(TextEditingController addressController) async {
    const currentAddress = 'Adresse actuelle de l\'hôtel'; // Simule l'obtention de l'adresse actuelle
    addressController.text = currentAddress;
  }

  void swapAddress(
    TextEditingController addressController,
    TextEditingController destinationController,
    bool isDefaultAddress,
    Function calculateEstimation,
  ) {
    isDefaultAddress = !isDefaultAddress;
    addressController.text = isDefaultAddress ? 'Adresse de départ' : '';
    destinationController.text = isDefaultAddress ? '' : 'Adresse de destination';
    calculateEstimation();
  }

  Future<void> selectDate(BuildContext context, Function(DateTime) onDateSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      locale: const Locale('fr', 'FR'),
    );
    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  Future<void> selectTime(BuildContext context, Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }

  Future<void> calculateEstimation(
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    TextEditingController addressController,
    TextEditingController destinationController,
    Function(String, String, String) onEstimationCalculated,
  ) async {
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
          onEstimationCalculated(
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

  Future<void> saveReservationData(
    int currentStep,
    String address,
    String destination,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    BuildContext context,
  ) async {
    await LocalStorageService.saveData('current_step', currentStep);
    await LocalStorageService.saveData('address', address);
    await LocalStorageService.saveData('destination', destination);
    if (selectedDate != null) {
      await LocalStorageService.saveData('selected_date', selectedDate.toIso8601String());
    }
    if (selectedTime != null) {
      await LocalStorageService.saveData('selected_time', selectedTime.format(context));
    }
  }

  Future<void> saveVehicleData(
    String vehicleType,
    String seats,
    String trunk,
    String fuel,
    String price,
    String imagePath,
  ) async {
    await LocalStorageService.saveData('vehicle_type', vehicleType);
    await LocalStorageService.saveData('seats', seats);
    await LocalStorageService.saveData('trunk', trunk);
    await LocalStorageService.saveData('fuel', fuel);
    await LocalStorageService.saveData('price', price);
    await LocalStorageService.saveData('image_path', imagePath);
  }

  Future<void> removeReservationData() async {
    await LocalStorageService.removeData('current_step');
    await LocalStorageService.removeData('address');
    await LocalStorageService.removeData('destination');
    await LocalStorageService.removeData('selected_date');
    await LocalStorageService.removeData('selected_time');
    await LocalStorageService.removeData('vehicle_type');
    await LocalStorageService.removeData('seats');
    await LocalStorageService.removeData('trunk');
    await LocalStorageService.removeData('fuel');
    await LocalStorageService.removeData('price');
    await LocalStorageService.removeData('image_path');
  }

  Future<List<dynamic>> getVehicules() async {
    final response = await _apiService.getData('/gve/vehicules/');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Future<List<dynamic>> getPaymentMethods() async {
    final response = await _apiService.getData('/gve/methodes/');
    if (response.statusCode == 200) {
      return response.data
          .where((method) => method['is_active'])
          .map((method) => {
                'nom': method['nom'],
                'label': _formatPaymentMethodName(method['nom']),
                'description': method['description']
              })
          .toList();
    } else {
      throw Exception('Failed to load payment methods');
    }
  }

  String _formatPaymentMethodName(String method) {
    switch (method) {
      case 'payement_paypal':
        return 'Paiement par PayPal';
      case 'payement_stripe':
        return 'Paiement par Stripe';
      case 'payement_abord':
        return 'Paiement à bord (espèce ou CB)';
      case 'payement_virement':
        return 'Paiement par virement bancaire';
      case 'payment_en_compte':
        return 'Paiement en compte';
      default:
        return method;
    }
  }
}
