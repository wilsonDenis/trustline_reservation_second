import 'package:flutter/foundation.dart';
import 'package:trust_reservation_second/services/api_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:trust_reservation_second/services/notification_service.dart';

class MessageService {
  final ApiService _apiService = ApiService();

  String getChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0 ? '$userId1\_$userId2' : '$userId2\_$userId1';
  }

Future<void> sendMessage(String messageText, String receiverId) async {
  try {
    // Récupération des IDs en tant que chaîne de caractères
    String? userId = (await LocalStorageService.getData('userId'))?.toString();
    String? specificId = (await LocalStorageService.getData('specific_id'))?.toString();
    String? userType = (await LocalStorageService.getData('user_type'))?.toString();

    // Déterminer le senderId en fonction du type d'utilisateur
    String senderId = '';
    if (userType == 'hotel') {
      senderId = specificId ?? '';
    } else if (userType == 'chauffeur') {
      senderId = userId ?? '';
    }

    // Log des IDs pour le débogage
    if (kDebugMode) {
      print('Sender ID: $senderId, Receiver ID: $receiverId');
    }

    // Vérification des IDs
    if (senderId.isEmpty || receiverId.isEmpty || receiverId == "0") {
      throw Exception('Sender or Receiver ID is invalid');
    }

    final data = {
      'senderId': senderId,
      'receiver': receiverId,
      'content': messageText,
    };

    await _apiService.postData('/auth/messages/', data);
    NotificationService.showInstantNotification('Nouveau message', messageText);
  } catch (e) {
    if (kDebugMode) {
      print('Error sending message: $e');
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

  Stream<List<Map<String, dynamic>>> streamMessages(int chatId) async* {
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
