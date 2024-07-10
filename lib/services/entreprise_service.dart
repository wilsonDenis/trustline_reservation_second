import 'package:dio/dio.dart';
import 'package:trust_reservation_second/services/api_service.dart';

class EntrepriseServiceDio{
  final ApiService _apiServiceDio = ApiService();

  Future<Response> addEntreprisePartenaire(Map<String, dynamic> data) async {
    return await _apiServiceDio.postData('/gve/addEntrepisePartemaire', data);
  }

  Future<Response> addMonEntreprise(Map<String, dynamic> data) async {
    return await _apiServiceDio.postData('/gve/addMonEntreprise', data);
  }

  Future<Response> getEntreprises() async {
    return await _apiServiceDio.getData('/gve/entreprises');
  }

  Future<Response> getEntrepriseDetails(int entrepriseId) async {
    return await _apiServiceDio.getData('/gve/entreprises/$entrepriseId');
  }

  Future<Response> updateEntreprise(int entrepriseId, Map<String, dynamic> data) async {
    return await _apiServiceDio.putData('/gve/updatePrix/$entrepriseId', data);
  }
}
