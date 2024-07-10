import 'package:dio/dio.dart';
import 'package:trust_reservation_second/services/api_service.dart';


class ChauffeurService {
  final ApiService _apiService= ApiService();

  Future<Response> createChauffeur(Map<String, dynamic> data) async {
    return await _apiService.postData('/auth/chauffeur', data);
  }

  Future<Response> getChauffeurs() async {
    return await _apiService.getData('/auth/chauffeurs');
  }

  Future<Response> updateChauffeur(int chauffeurId, Map<String, dynamic> data) async {
    return await _apiService.putData('/auth/chauffeur/$chauffeurId', data);
  }

  Future<Response> deleteChauffeur(int chauffeurId) async {
    return await _apiService.deleteData('/auth/chauffeur/$chauffeurId');
  }
}
