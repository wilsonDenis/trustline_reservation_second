import 'package:dio/dio.dart';
import 'package:trust_reservation_second/services/api_service.dart';

class EntrepriseService{
  final ApiService _apiService = ApiService();

  Future<Response> addEntreprisePartenaire(Map<String, dynamic> data) async {
    return await _apiService.postData('/gve/addEntrepisePartemaire', data);
  }

  Future<Response> addMonEntreprise(Map<String, dynamic> data) async {
    return await _apiService.postData('/gve/addMonEntreprise', data);
  }

  Future<Response> getEntreprises() async {
    return await _apiService.getData('/gve/entreprises');
  }

  Future<Response> getEntrepriseDetails(int entrepriseId) async {
    return await _apiService.getData('/gve/entreprises/$entrepriseId');
  }

  Future<Response> updateEntreprise(int entrepriseId, Map<String, dynamic> data) async {
    return await _apiService.putData('/gve/updatePrix/$entrepriseId', data);
  }
}
