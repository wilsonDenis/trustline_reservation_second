import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  Future<String?> getAuthToken() async {
    return await LocalStorageService.getData('token');
  }

  Future<Response> postData(String endpoint, Map<String, dynamic> data, {bool requireToken = true}) async {
    if (requireToken) {
      final token = await getAuthToken();
      if (token != null) {
        _dioClient.dio.options.headers["Authorization"] = "Bearer $token";
      }
    }

    if (kDebugMode) {
      print('POST request to: ${_dioClient.dio.options.baseUrl}$endpoint');
      print('Headers: ${_dioClient.dio.options.headers}');
      print('Body: $data');
    }

    final response = await _dioClient.dio.post(endpoint, data: data);

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
    }

    return response;
  }

  Future<Response> getData(String endpoint) async {
    final token = await getAuthToken();
    if (token != null) {
      _dioClient.dio.options.headers["Authorization"] = "Bearer $token";
    }

    if (kDebugMode) {
      print('GET request to: ${_dioClient.dio.options.baseUrl}$endpoint');
      print('Headers: ${_dioClient.dio.options.headers}');
    }

    final response = await _dioClient.dio.get(endpoint);

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
    }

    return response;
  }

  Future<Response> putData(String endpoint, Map<String, dynamic> data) async {
    final token = await getAuthToken();
    if (token != null) {
      _dioClient.dio.options.headers["Authorization"] = "Bearer $token";
    }

    if (kDebugMode) {
      print('PUT request to: ${_dioClient.dio.options.baseUrl}$endpoint');
      print('Headers: ${_dioClient.dio.options.headers}');
      print('Body: $data');
    }

    final response = await _dioClient.dio.put(endpoint, data: data);

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
    }

    return response;
  }

  Future<Response> deleteData(String endpoint) async {
    final token = await getAuthToken();
    if (token != null) {
      _dioClient.dio.options.headers["Authorization"] = "Bearer $token";
    }

    if (kDebugMode) {
      print('DELETE request to: ${_dioClient.dio.options.baseUrl}$endpoint');
      print('Headers: ${_dioClient.dio.options.headers}');
    }

    final response = await _dioClient.dio.delete(endpoint);

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
    }

    return response;
  }
}
