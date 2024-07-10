import 'package:dio/dio.dart';
import 'package:trust_reservation_second/services/api_service.dart';


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
}
