import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:trust_reservation_second/services/api_service.dart';
import 'package:trust_reservation_second/services/notification_service.dart';


class ReservationServiceNotifif {
  final ApiService _apiService = ApiService();

  Future<Response> createReservation(Map<String, dynamic> data) async {
    final response = await _apiService.postData('/reservations', data);

    if (response.statusCode == 201) {
      // Vérification du statut 201 (Créé)
      // Notification de l'administrateur
      await NotificationService.sendApiNotification(
        1, // Assuming 1 is the admin userId
        'New Reservation Created',
        'A new reservation has been created.',
      );

      // Notification aux chauffeurs
      final chauffeurs = await _apiService.getData('/auth/chauffeurs');
      if (chauffeurs.statusCode == 200) {
        final chauffeurList = jsonDecode(chauffeurs.data) as List;
        for (var chauffeur in chauffeurList) {
          await NotificationService.sendApiNotification(
            chauffeur['id'],
            'New Job Assigned',
            'A new reservation has been assigned to you.',
          );
        }
      }

      return response;
    } else {
      // Gestion des erreurs en fonction du code de réponse
      if (response.statusCode == 400) {
        // Erreur de validation
        // Afficher un message d'erreur à l'utilisateur
      } else if (response.statusCode == 500) {
        // Erreur serveur
        // Afficher un message d'erreur à l'utilisateur
      } else {
        // Autre erreur
        // Afficher un message d'erreur général
      }
      return response;
    }
  }

  Future<Response> getReservations() async {
    return await _apiService.getData('/reservations');
  }

  Future<Response> updateReservation(int reservationId, Map<String, dynamic> data) async {
    return await _apiService.putData('/reservations/$reservationId', data);
  }

  Future<Response> deleteReservation(int reservationId) async {
    return await _apiService.deleteData('/reservations/$reservationId');
  }
}
