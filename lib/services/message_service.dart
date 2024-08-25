import 'package:flutter/foundation.dart';
import 'package:trust_reservation_second/services/api_service.dart';
import 'package:trust_reservation_second/services/notification_service.dart';

class MessageService {
  final ApiService _apiService = ApiService();

  String getChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0 ? '${userId1}_$userId2' : '${userId2}_$userId1';
  }
Future<void> sendMessage(String messageText, String senderId, String receiverId) async {
    try {
        // Préparation des données pour l'envoi
        final data = {
            'sender': senderId,
            'receiver': receiverId,
            'content': messageText,
        };

        // Envoi des données via l'API
        final response = await _apiService.postData('/auth/messages/', data);

        if (response.statusCode == 201) {
            if (kDebugMode) {
                print('Message envoyé avec succès : $messageText');
            }

            // Déclenchement de la notification locale pour le destinataire
            if (senderId != receiverId) {
                NotificationService.showInstantNotification(
                    'Nouveau message',
                    'Message de $senderId : $messageText',
                );
            }
        } else {
            throw Exception('Erreur lors de l\'envoi du message');
        }
    } catch (e) {
        if (kDebugMode) {
            print('Erreur lors de l\'envoi du message : $e');
        }
        rethrow;
    }
}

  Future<List<Map<String, dynamic>>> getMessages(int chatId) async {
    if (chatId <= 0) {
      throw Exception('Invalid chat ID');
    }

    try {
      final response = await _apiService.getData('/auth/messages/$chatId/');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting messages: $e');
      }
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> streamMessages(int chatId) async*{
    if (chatId <= 0) {
      yield [];  // Pas de messages pour un ID de chat invalide
      return;
    }

    while (true) {
      try {
        final messages = await getMessages(chatId);
        yield messages;
      } catch (e) {
        if (kDebugMode) {
          print('Error streaming messages: $e');
        }
        yield []; // Yield an empty list on error
      }
      await Future.delayed(const Duration(seconds: 5)); // Polling interval
    }
  }
}





