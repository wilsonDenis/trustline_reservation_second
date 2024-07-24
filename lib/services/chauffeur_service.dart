import 'package:dio/dio.dart';
import 'package:trust_reservation_second/services/api_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';


class ChauffeurService {
  final ApiService _apiService = ApiService();

  Future<Response> createChauffeur(Map<String, dynamic> data) async {
    return await _apiService.postData('/auth/chauffeurFlutter/', data);
  }

  // Future<Response> getChauffeurInfo(int chauffeurId) async {
  //   return await _apiService.getData('/auth/chauffeur/$chauffeurId/');
  // }

   Future<Response> getChauffeurInfo() async {
    final int chauffeurId = await LocalStorageService.getData('userId');
    return await _apiService.getData('/auth/chauffeur/$chauffeurId/');
   }

  Future<Response> getTodayTrip(int chauffeurId) async {
    return await _apiService.getData('/trip/today/$chauffeurId');
  }

  Future<Response> getRating(int chauffeurId) async {
    return await _apiService.getData('/rating/$chauffeurId');
  }

  Future<Response> updateChauffeur(Map<String, dynamic> data) async {
    final int chauffeurId = await LocalStorageService.getData('userId');
    return await _apiService.putData('/auth/chauffeurCrudFlutter/$chauffeurId/', data);
  }

  Future<Response> deleteChauffeur(int chauffeurId) async {
    return await _apiService.deleteData('/auth/chauffeurCrudFlutter/$chauffeurId/');
  }
}


// class ChauffeurService {
//   final ApiService _apiService = ApiService();

//   Future<Response> createChauffeur(Map<String, dynamic> data) async {
//     return await _apiService.postData('/auth/chauffeurFlutter/', data);
//   }

  // Future<Response> getChauffeurInfo() async {
  //   final int chauffeurId = await LocalStorageService.getData('specific_id');
  //   return await _apiService.getData('/auth/chauffeur/$chauffeurId/');
  

//   Future<Response> getTodayTrip() async {
//     final int chauffeurId = await LocalStorageService.getData('specific_id');
//     return await _apiService.getData('/trip/today/$chauffeurId');
//   }

//   Future<Response> getRating() async {
//     final int chauffeurId = await LocalStorageService.getData('specific_id');
//     return await _apiService.getData('/rating/$chauffeurId');
//   }

//   Future<Response> updateChauffeur(Map<String, dynamic> data) async {
//     final int chauffeurId = await LocalStorageService.getData('specific_id');
//     return await _apiService.putData('/auth/chauffeurFlutter/$chauffeurId/', data);
//   }

//   Future<Response> deleteChauffeur() async {
//     final int chauffeurId = await LocalStorageService.getData('specific_id');
//     return await _apiService.deleteData('/auth/chauffeurFlutter/$chauffeurId/');
//   }
// }