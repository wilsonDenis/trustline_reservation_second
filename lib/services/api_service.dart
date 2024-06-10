import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _serverIP = '192.168.1.65';
  static const String baseUrl = 'http://$_serverIP:8000/api';

  static Future<String?> getAuthToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  static T _handleResponse<T>(
      http.Response response, T Function(dynamic) modelFromJson) {
    if (response.statusCode == 200) {
      return modelFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  static Future<http.Response> _postData(
      String endpoint, Map<String, dynamic> data,
      {bool requireToken = true}) async {
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

    return response;
  }

  static Future<http.Response> _updateData(
      String endpoint, Map<String, dynamic> data) async {
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

    return response;
  }

  // Authentification
  static Future<http.Response> login(String emailOrPhone, String password) async {
    final response = await _postData('/login', {
      'email_ou_telephone': emailOrPhone,
      'passCode': password,
    }, requireToken: false);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('token', responseData['token']);
      await pref.setString('role', responseData['type_utilisateur']);
    }

    return response;
  }

  static Future<http.Response> register(Map<String, dynamic> data) async {
    return _postData('/register', data, requireToken: false);
  }

  static Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('token');
    await pref.remove('role');
  }

  static Future<String?> getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('role');
  }

  static Future<http.Response> forgotPassword(String email) async {
    return _postData('/forgot-password', {'email': email}, requireToken: false);
  }

  static Future<http.Response> resetPassword(
      String token, String newPassword) async {
    return _postData('/reset-password', {
      'token': token,
      'new_password': newPassword,
    }, requireToken: false);
  }
}
