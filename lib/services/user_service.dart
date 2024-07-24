import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trust_reservation_second/services/api_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<Response> createUser(Map<String, dynamic> data) async {
    return await _apiService.postData('/users', data);
  }

  Future<Response> getUser(int userId) async {
    return await _apiService.getData('/users/$userId');
  }

  Future<Response> updateUser(int userId, Map<String, dynamic> data) async {
    return await _apiService.putData('/users/$userId', data);
  }

  Future<Response> deleteUser(int userId) async {
    return await _apiService.deleteData('/users/$userId');
  }

  // Future<Response> getHotelInfo(int hotelId) async {
  //   return await _apiService.getData('/auth/hotels/$hotelId/');
  // }
  Future<Response> getHotelInfo(int hotelId) async {
    final response = await _apiService.getData('/auth/hotels/$hotelId/');
    if (response.statusCode == 404) {
      print('Hotel not found. Check the URL and hotelId.');
    }
    return response;
  }

  

  Future<Response> calculateDistance(Map<String, dynamic> data) async {
    return await _apiService.postData('/estimation/calculDistance/', data);
  }
  // Future<Response> calculateDistance(Map<String, dynamic> data) async {
  //   return await _apiService.postData('/estimation/SimpleCalculateDistance/', data);
  // }


   Future<Map<String, dynamic>> getUserInfo() async {
    final userId = await LocalStorageService.getData('userId');
    final userType = await LocalStorageService.getData('user_type');
    final specificId = await LocalStorageService.getData('specific_id');
    if (kDebugMode) {
      print('-------------------------------voici :  userId: $userId, userType: $userType, specificId: $specificId------');
    }
    return {
      'userId': userId,
      'userType': userType,
      'specificId': specificId,
    };
  }
}

