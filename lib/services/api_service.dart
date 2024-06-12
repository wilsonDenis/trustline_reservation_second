import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/services/notification_service.dart';

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
    try {
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
        print('POST $endpoint response: ${response.body}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error in _postData: $e');
      }
      rethrow;
    }
  }

  static Future<http.Response> _indexData(String endpoint) async {
    try {
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
        print('GET $endpoint response: ${response.body}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error in _indexData: $e');
      }
      rethrow;
    }
  }

  static Future<http.Response> _updateData(String endpoint, Map<String, dynamic> data) async {
    try {
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
        print('PUT $endpoint response: ${response.body}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error in _updateData: $e');
      }
      rethrow;
    }
  }

  static Future<http.Response> _deleteData(String endpoint) async {
    try {
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
        print('DELETE $endpoint response: ${response.body}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error in _deleteData: $e');
      }
      rethrow;
    }
  }

  // Authentification
  static Future<http.Response> login(Map<String, dynamic> data) async {
    return await _postData('/login', data, requireToken: false);
  }

  static Future<http.Response> register(Map<String, dynamic> data) async {
    return await _postData('/register', data, requireToken: false);
  }

  static Future<void> logout() async {
    final response = await _postData('/logout', {});
    if (response.statusCode == 200) {
      await LocalStorageService.removeData('token');
      await LocalStorageService.removeData('userId');
    }
  }

  // Gestion des utilisateurs
  static Future<http.Response> createUser(Map<String, dynamic> data) async {
    return await _postData('/users', data);
  }

  static Future<http.Response> getUser(int userId) async {
    return await _indexData('/users/$userId');
  }

  static Future<http.Response> updateUser(int userId, Map<String, dynamic> data) async {
    return await _updateData('/users/$userId', data);
  }

  static Future<http.Response> deleteUser(int userId) async {
    return await _deleteData('/users/$userId');
  }

  // Gestion des chauffeurs
  static Future<http.Response> createChauffeur(Map<String, dynamic> data) async {
    return await _postData('/chauffeurs', data);
  }

  static Future<http.Response> getChauffeurs() async {
    return await _indexData('/chauffeurs');
  }

  static Future<http.Response> updateChauffeur(int chauffeurId, Map<String, dynamic> data) async {
    return await _updateData('/chauffeurs/$chauffeurId', data);
  }

  static Future<http.Response> deleteChauffeur(int chauffeurId) async {
    return await _deleteData('/chauffeurs/$chauffeurId');
  }

  // Gestion des hôtels
  static Future<http.Response> createHotel(Map<String, dynamic> data) async {
    return await _postData('/hotels', data);
  }

  static Future<http.Response> getHotels() async {
    return await _indexData('/hotels');
  }

  static Future<http.Response> updateHotel(int hotelId, Map<String, dynamic> data) async {
    return await _updateData('/hotels/$hotelId', data);
  }

  static Future<http.Response> deleteHotel(int hotelId) async {
    return await _deleteData('/hotels/$hotelId');
  }

  // Gestion des réservations
  static Future<http.Response> createReservation(Map<String, dynamic> data) async {
    final response = await _postData('/reservations', data);

    if (response.statusCode == 200) {
      // Notify admin
      NotificationService.sendApiNotification(
        1, // Assuming 1 is the admin userId
        'New Reservation Created',
        'A new reservation has been created.',
      );

      // Notify chauffeurs
      final chauffeurs = await getChauffeurs();
      if (chauffeurs.statusCode == 200) {
        final chauffeurList = jsonDecode(chauffeurs.body) as List;
        for (var chauffeur in chauffeurList) {
          NotificationService.sendApiNotification(
            chauffeur['id'],
            'New Job Assigned',
            'A new reservation has been assigned to you.',
          );
        }
      }
    }

    return response;
  }

  static Future<http.Response> getReservations() async {
    return await _indexData('/reservations');
  }

  static Future<http.Response> updateReservation(int reservationId, Map<String, dynamic> data) async {
    return await _updateData('/reservations/$reservationId', data);
  }

  static Future<http.Response> deleteReservation(int reservationId) async {
    return await _deleteData('/reservations/$reservationId');
  }

  // Notifications
  static Future<void> sendNotification(Map<String, dynamic> data) async {
    await _postData('/notifications', data);
  }

  // Messagerie et chat
  static Future<http.Response> checkChatExists(int userId1, int userId2) async {
    return await _indexData('/chat/exists/$userId1/$userId2');
  }

  static Future<http.Response> getChatMessages(int userId1, int userId2) async {
    return await _indexData('/chat/get/$userId1/$userId2');
  }

  static Future<http.Response> sendChatMessage(int receiverId, String message, int type) async {
    Map<String, dynamic> data = {
      'receiver_id': receiverId,
      'message': message,
      'type': type,
    };
    return await _postData('/chat/send', data);
  }

  static Future<http.Response> initiateOrGetChatForReservation(int reservationId) async {
    return await _postData('/chat/initiate/$reservationId', {});
  }

  static Future<http.Response> getRecentChats() async {
    return await _indexData('/chat/recent');
  }
}
