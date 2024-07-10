import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:trust_reservation_second/services/api_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';

class AuthService{
  final ApiService _apiService = ApiService();

  Future<Response> login(Map<String, dynamic> data) async {
    return await _apiService.postData('/auth/login/', data, requireToken: false);
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return await _apiService.postData('/auth/register/', data, requireToken: false);
  }

  Future<void> logout() async {
    if (kDebugMode) {
      print('Début de la déconnexion...');
    }
    try {
      final response = await _apiService.postData('/auth/logout/', {});
      if (response.statusCode == 200) {
        await LocalStorageService.removeData('token');
        await LocalStorageService.removeData('userId');
        if (kDebugMode) {
          print('Déconnexion réussie.');
        }
      } else {
        if (kDebugMode) {
          print('Erreur lors de la déconnexion : ${response.statusCode} - ${response.data}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception lors de la déconnexion : $e');
      }
    }
  }
}
