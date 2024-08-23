import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trust_reservation_second/services/api_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<Response> createUser(Map<String, dynamic> data) async {
    return await _apiService.postData('/users', data);
  }
  Future<Response> createReceptionniste(Map<String, dynamic> data) async {
    return await _apiService.postData('/auth/creer_receptionniste/', data);
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
      if (kDebugMode) {
        print('Hotel not found. Check the URL and hotelId.');
      }
    }
    return response;
  }

  

  Future<Response> calculateDistance(Map<String, dynamic> data) async {
    return await _apiService.postData('/estimation/calculDistance/', data);
  }
 

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



   Future<Response> getReceptionnistes() async {
    return await _apiService.getData('/auth/receptionnistes/');
  }

  Future<Response> deleteReceptionniste(int id) async {
    return await _apiService.deleteData('/auth/receptionnistes/delete/$id/');
  }

  Future<Response> updateReceptionniste(int id, Map<String, dynamic> data) async {
    return await _apiService.putData('/auth/receptionnistes/update/$id/', data);
  }

   // Nouvelle méthode pour récupérer tous les chauffeurs
  Future<List<Map<String, dynamic>>> getAllChauffeurs() async {
    if (kDebugMode) {
      print('Récupération de tous les chauffeurs...');
    }
    
    final response = await _apiService.getData('/gve/chauffeurs/');
    
    if (kDebugMode) {
      print('Status code de la réponse pour chauffeurs: ${response.statusCode}');
      print('Réponse pour chauffeurs: ${response.data}');
    }

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Failed to load chauffeurs');
    }
  }

  // Nouvelle méthode pour récupérer tous les hôtels
  Future<List<Map<String, dynamic>>> getAllHotels() async {
    if (kDebugMode) {
      print('Récupération de tous les hôtels...');
    }
    
    final response = await _apiService.getData('/auth/hotelsAll/');
    
    if (kDebugMode) {
      print('Status code de la réponse pour hôtels: ${response.statusCode}');
      print('Reponse pour hôtels: ${response.data}');
    }

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Failed to load hotels');
    }
  }

  // Méthode pour récupérer et fusionner tous les utilisateurs par type
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      if (kDebugMode) {
        print('Recuperation de tous les utilisateurs (chauffeurs et hotels)...');
      }
      
      List<Map<String, dynamic>> allUsers = [];

      // Récupérer tous les chauffeurs
      final chauffeurs = await getAllChauffeurs();
      if (kDebugMode) {
        print('Nombre de chauffeurs recuperes: ${chauffeurs.length}');
      }
      allUsers.addAll(chauffeurs);

      // Récupérer tous les hôtels
      final hotels = await getAllHotels();
      if (kDebugMode) {
        print('Nombre d\'hotels recupereres: ${hotels.length}');
      }
      allUsers.addAll(hotels);

      if (kDebugMode) {
        print('Total des utilisateurs recuperes: ${allUsers.length}');
      }

      return allUsers;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des utilisateurs: $e');
      }
      throw Exception('Failed to load users: $e');
    }
  }

//   api/gve/ chauffeurs/ [name='chauffeur-list-create']
// api/gve/ chauffeurs/<int:pk>/ [name='chauffeur-detail']
// api/auth/ hotels/<int:id>/ [name='hotels-detail']
// la liste des personne et trier en fonction de TYPE_UTILISATEUR chauffeur et hotel

// - pour récupérer les détails d’un chauffeur spécifique
// Tu passe en paramètre a la route ci dessous l’id de personne (id)
//     path('chauffeur/<int:pk>/', ChauffeurDetailView.as_view(), name='chauffeur-detail'),
// -  pour récupérer les détails hôtel spécifique  Tu passe en paramètre a la route ci dessous l’id de personne (id)   path('hotels/<int:id>/', HotelsView.as_view(), name='hotels-detail'),

// les routes :/gve/chauffeurs/<int:pk>/ [name='chauffeur-detail']
// /auth/hotels/<int:id>/ [name='hotels-detail']

// api/auth/ hotelsActions/<int:id>/ [name='hotels-detail']


// api/auth/ receptionnistes/ [name='list-receptionnistes']
// api/auth/ receptionnistes/<int:id>/ [name='edit-receptionniste']
// api/auth/ receptionnistes/delete/<int:id>/ [name='delete-receptionniste']


}

