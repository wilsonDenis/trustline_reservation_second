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
// // ------------------MISE A JOUR HOTEL
//   Future<Response> updateHotel(Map<String, dynamic> data) async {
//     return await _apiService.putData('/auth/hotels/update/', data);
//   }


  Future<Response> updateHotel(dynamic data, {required bool isFormData}) async {
    if (data is FormData) {
      return await _apiService.putDataWithFormData('/auth/hotels/update/', data);
    } else if (data is Map<String, dynamic>) {
      return await _apiService.putData('/auth/hotels/update/', data);
    } else {
      throw ArgumentError('Invalid data type: ${data.runtimeType}');
    }
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
      print('-----------------getUserInfo()voici :  userId: $userId, userType: $userType, specificId: $specificId------');
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
    print('Démarrage de la récupération de tous les chauffeurs...');
  }

  try {
    final response = await _apiService.getData('/gve/chauffeurs/');

    if (kDebugMode) {
      print('Status code de la réponse pour chauffeurs: ${response.statusCode}');
      print('Réponse brute pour chauffeurs: ${response.data}');
    }

    // Vérification du statut de la réponse
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> chauffeurs = List<Map<String, dynamic>>.from(response.data);

      // Vérification et affichage des informations des chauffeurs
      for (var chauffeur in chauffeurs) {
        String firstName = chauffeur['first_name'] ?? 'Prénom non disponible';
        String lastName = chauffeur['last_name'] ?? 'Nom non disponible';
        String idChauffeur = chauffeur['personne_ptr']?.toString() ?? 'ID non disponible'; // Utilisation de `personne_ptr`
        String typeUtilisateur=chauffeur['type_utilisateur'];

        if (kDebugMode) {
          print('--------USERSERVICE-------getAllChauffeurs(): Chauffeur récupéré — Nom: $firstName $lastName, ID: $idChauffeur    type_utilisateur: $typeUtilisateur',);
        }
      }

      return chauffeurs;
    } else {
      if (kDebugMode) {
        print('Échec de la récupération des chauffeurs. Statut de la réponse: ${response.statusCode}');
      }
      throw Exception('Erreur lors du chargement des chauffeurs');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Exception lors de la récupération des chauffeurs: $e');
    }
    throw Exception('Erreur lors de la récupération des chauffeurs: $e');
  }
}


Future<List<Map<String, dynamic>>> getAllHotels() async {
  if (kDebugMode) {
    print('Récupération de tous les hôtels...');
  }

  final response = await _apiService.getData('/auth/hotelsAll/');

  if (kDebugMode) {
    print('Status code de la réponse pour hôtels: ${response.statusCode}');
    print('Réponse pour hôtels: ${response.data}');
  }

  if (response.statusCode == 200) {
    List<Map<String, dynamic>> hotels = List<Map<String, dynamic>>.from(response.data);
    
    // Utilisation de l'ID du gérant comme identifiant de l'hôtel
    for (var hotel in hotels) {
      var hotelId = hotel['gerant']['id']; // Utilisation de l'ID du gérant
      var typeUtilisateur=hotel['gerant']['type_utilisateur'];
      if (kDebugMode) {
        print('Hôtel récupéré— Nom: ${hotel['nom']}, ID du gérant: $hotelId , type_utilisateur: $typeUtilisateur');
      }
    }
    
    return hotels;
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
            print('--------USERSERVICE-------getAllUsers(): Nombre d\'hotels recupereres: ${hotels.length}');
        }
        allUsers.addAll(hotels);

        if (kDebugMode) {
            print('Total des utilisateurs recuperes -----USERSERVICE-------getAllUsers(): ${allUsers.length}');
            for (var user in allUsers) {
                print('Utilisateur récupéré: ${user['first_name']} ${user['last_name']}, Type: ${user['type_utilisateur']}, ID: ${user['personne_ptr']}');
            }
        }

        return allUsers;
    } catch (e) {
        if (kDebugMode) {
            print('Erreur lors de la récupération des utilisateurs: $e');
        }
        throw Exception('Failed to load users: $e');
    }
}



}

