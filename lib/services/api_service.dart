import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:trust_reservation_second/services/local_storage.dart';

class ApiService {
  static const String _serverIP = '192.168.1.65';
  static const String baseUrl = 'http://$_serverIP:8000/api';
  static String get serverIP => _serverIP;
  static String currentIP = serverIP;

  static Future<String?> getAuthToken() async {
    return await LocalStorageService.getData('token');
  }

  static T _handleResponse<T>(http.Response response, T Function(dynamic) modelFromJson) {
    if (response.statusCode == 200) {
      return modelFromJson(jsonDecode(response.body));
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode} and body: ${response.body}');
      }
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  static Future<http.Response> _postData(String endpoint, Map<String, dynamic> data, {bool requireToken = true}) async {
    String? authToken;
    if (requireToken) {
      authToken = await getAuthToken();
    }

    final headers = {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
    
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(data),
    );
    
    if (kDebugMode) {
      print('Response body: ${response.body}');
    }
    
    return response;
  }

  static Future<http.Response> _indexData(String endpoint) async {
    final authToken = await getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    
    final response = await http.get(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
    );
    
    if (kDebugMode) {
      print('Response body: ${response.body}');
    }
    
    return response;
  }

  static Future<http.Response> _updateData(String endpoint, Map<String, dynamic> data) async {
    final authToken = await getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    
    final response = await http.put(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(data),
    );
    
    if (kDebugMode) {
      print('Response body: ${response.body}');
    }
    
    return response;
  }

  static Future<http.Response> _deleteData(String endpoint) async {
    final authToken = await getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    
    final response = await http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
    );
    
    if (kDebugMode) {
      print('Response body: ${response.body}');
    }
    
    return response;
  }

  // ----------------------Authentification----------------
  static Future<http.Response> login(Map<String, dynamic> data) {
    return _postData('/login', data, requireToken: false);
  }

  static Future<http.Response> register(Map<String, dynamic> data) {
    return _postData('/register', data, requireToken: false);
  }

  static Future<void> logout() async {
    final response = await _postData('/logout', {});
    if (response.statusCode == 200) {
      await LocalStorageService.removeData('token');
      await LocalStorageService.removeData('userId');
    }
  }

  //--------------- Gestion des utilisateurs------------------------
  static Future<http.Response> createUser(Map<String, dynamic> data) {
    return _postData('/users', data);
  }

  static Future<http.Response> getUser(int userId) {
    return _indexData('/users/$userId');
  }

  static Future<http.Response> updateUser(int userId, Map<String, dynamic> data) {
    return _updateData('/users/$userId', data);
  }

  static Future<http.Response> deleteUser(int userId) {
    return _deleteData('/users/$userId');
  }

  // ----------------------Gestion des chauffeurs------------------
  static Future<http.Response> createChauffeur(Map<String, dynamic> data) {
    return _postData('/chauffeurs', data);
  }

  static Future<http.Response> getChauffeurs() {
    return _indexData('/chauffeurs');
  }

  static Future<http.Response> updateChauffeur(int chauffeurId, Map<String, dynamic> data) {
    return _updateData('/chauffeurs/$chauffeurId', data);
  }

  static Future<http.Response> deleteChauffeur(int chauffeurId) {
    return _deleteData('/chauffeurs/$chauffeurId');
  }

  //--------------------------- Gestion des hôtels---------------
  static Future<http.Response> createHotel(Map<String, dynamic> data) {
    return _postData('/hotels', data);
  }

  static Future<http.Response> getHotels() {
    return _indexData('/hotels');
  }

  static Future<http.Response> updateHotel(int hotelId, Map<String, dynamic> data) {
    return _updateData('/hotels/$hotelId', data);
  }

  static Future<http.Response> deleteHotel(int hotelId) {
    return _deleteData('/hotels/$hotelId');
  }

  //----------------- Gestion des réservations-----------------------
  static Future<http.Response> createReservation(Map<String, dynamic> data) {
    return _postData('/reservations', data);
  }

  static Future<http.Response> getReservations() {
    return _indexData('/reservations');
  }

  static Future<http.Response> updateReservation(int reservationId, Map<String, dynamic> data) {
    return _updateData('/reservations/$reservationId', data);
  }

  static Future<http.Response> deleteReservation(int reservationId) {
    return _deleteData('/reservations/$reservationId');
  }

  // ---------------Notifications------------------------------
  static Future<void> sendNotification(Map<String, dynamic> data) async {
    await _postData('/notifications', data);
  }

  //-------------------- Messagerie et chat-----------------------
  static Future<http.Response> checkChatExists(int userId1, int userId2) {
    return _indexData('/chat/exists/$userId1/$userId2');
  }

  static Future<http.Response> getChatMessages(int userId1, int userId2) {
    return _indexData('/chat/get/$userId1/$userId2');
  }

  static Future<http.Response> sendChatMessage(int receiverId, String message, int type) {
    Map<String, dynamic> data = {
      'receiver_id': receiverId,
      'message': message,
      'type': type,
    };
    return _postData('/chat/send', data);
  }

  static Future<http.Response> initiateOrGetChatForReservation(int reservationId) {
    return _postData('/chat/initiate/$reservationId', {});
  }

  static Future<http.Response> getRecentChats() {
    return _indexData('/chat/recent');
  }
}
