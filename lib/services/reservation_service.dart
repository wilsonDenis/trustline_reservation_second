import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_reservation_second/services/api_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/services/user_service.dart';

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
    VoidCallback calculateEstimation,
  ) {
    isDefaultAddress = !isDefaultAddress;
    addressController.text = isDefaultAddress ? 'Adresse de départ' : '';
    destinationController.text = isDefaultAddress ? '' : 'Adresse de destination';
    calculateEstimation();
  }

  Future<void> selectDate(BuildContext context, ValueChanged<DateTime> onDateSelected) async {
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

  Future<void> selectTime(BuildContext context, ValueChanged<TimeOfDay> onTimeSelected) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }

  Future<Map<String, String>?> calculateEstimation(
    DateTime selectedDate,
    TimeOfDay selectedTime,
    String address,
    String destination,
  ) async {
    final datePriseEnChargeISO = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    ).toIso8601String();

    final formData = {
      'datePriseEnCharge': datePriseEnChargeISO,
      'departAddress': address,
      'destinationAddress': destination,
    };

    try {
      final response = await _userService.calculateDistance(formData);
      if (response.statusCode == 200) {
        return {
          'distance': response.data['distParcourt'].toString(),
          'duration': response.data['durParcourt'].toString(),
          'cost': response.data['transport_estimates'][0]['cout'].toString(),
        };
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during estimation calculation: $e');
      }
      return null;
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
      // ignore: use_build_context_synchronously
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

  Future<void> clearLocalStorage() async {
    await removeReservationData();
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
    final response = await _apiService.getData('/setting/methodes/');
  
    if (kDebugMode) {
      print('----------------Response status code: ${response.statusCode}');
      print('-------------Response data: ${response.data}');
    }
  
    if (response.statusCode == 200) {
      final activeMethods = response.data.where((method) => method['is_active'] == true).toList();
    
      if (kDebugMode) {
        print('---------------------Active methods: $activeMethods');
      }
    
      final paymentMethods = activeMethods.map((method) => {
        'nom': method['nom'],
        'label': method['nom'],
        'description': method['description'],
      }).toList();
    
      if (kDebugMode) {
        print('Payment methods: $paymentMethods');
      }
    
      return paymentMethods;
    } else {
      throw Exception('Failed to load payment methods');
    }
  }

  Future<List<Map<String, dynamic>>> getClients() async {
    try {
      final response = await _apiService.getData('/auth/clients/');
      if (kDebugMode) {
        print('---------------------TOUS LES CLIENTS: $response');
      }
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['clients']);
      } else {
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du chargement des clients : $e');
      }
      throw Exception('Erreur lors du chargement des clients : $e');
    }
  }

  Future<int> createClient(Map<String, dynamic> data) async {
    final response = await _apiService.postData('/auth/register/', data);
    if (response.statusCode == 201) {
      return response.data['id'];
    } else {
      throw Exception('Failed to create client');
    }
  }

  Future<Response> getClient(int clientId) async {
    return await _apiService.getData('/auth/clients/$clientId/');
  }

Future<void> createReservation(Map<String, dynamic> data) async {
  final bool isNewClient = data['client']['id'] == 0;

  final reservationData = {
    'client': isNewClient ? {
      'first_name': data['client']['first_name'] ?? '',
      'last_name': data['client']['last_name'] ?? '',
      'phone': data['client']['phone'] ?? '',
      'email': data['client']['email'] ?? '',
      'address': data['client']['address'] ?? ''
    } : data['client']['id'].toString(),
    'depart': data['depart'],
    'destination': data['destination'],
    'datePriseEnCharge': data['datePriseEnCharge'],
    'heurePriseEnCharge': data['heurePriseEnCharge'],
    'distance': data['distance'],
    'duree': data['duree'],
    'vehicule': int.tryParse(data['vehicule']) ?? 0,
    'nombrePassager': data['passagers'],
    'nombreBagage': data['bagages'],
    'modePaiement': data['modeDePaiement'],
    'numeroVolTrain': data['numeroVolTrain'] ?? '',
    'numeroDossier': data['numeroDossier'] ?? '',
    'notes': data['notes'] ?? '',
    'coutTransport': data['coutTransport'] ?? '0',
    'coutMajorer': data['coutMajorer'] ?? '0',
    'lieuxPriseEnCharge': data['lieuxPriseEnCharge'] ?? 'Unknown',
    'lieuxDestination': data['lieuxDestination'] ?? 'Unknown',
    'typeReservation': data['typeReservation'] ?? 'Standard',
    'coutTotalReservation': data['coutTotal'],
    'totalAttributCost': data['totalAttributCost'] ?? '0',
    'destinationInputs': data['destinationInputs'] ?? 'Default',
    'attribut': 1, // Ajout de l'attribut par défaut
    'utilisateur': data['utilisateur'],
    'client_partiel': data['client_partiel'],
  };

  try {
    final response = await _apiService.postData('/reservations/', reservationData);
    if (response.statusCode != 201) {
      throw Exception('Failed to create reservation');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error during reservation creation: $e');
    }
    throw Exception('Erreur lors de la création de la réservation : $e');
  }
}
  
  Future<Response> getReservation(int reservationId) async {
    return await _apiService.getData('/reservation/$reservationId/');
  }
}