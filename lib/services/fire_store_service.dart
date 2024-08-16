import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:trust_reservation_second/services/local_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String messageText, String receiverId) async {
    try {
      String senderId = await LocalStorageService.getData('userId');
      Timestamp timestamp = Timestamp.now();

      await _firestore.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'text': messageText,
        'timestamp': timestamp,
      });

      // Envoyer une notification lors de l'envoi du message
      _showNotification(messageText);
    } catch (e) {
      if (kDebugMode) {
        print('Error sending message: $e');
      }
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages(String userId1, String userId2) {
    return _firestore
        .collection('messages')
        .where('senderId', whereIn: [userId1, userId2])
        .where('receiverId', whereIn: [userId1, userId2])
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  Future<void> _showNotification(String messageText) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id', 
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await FlutterLocalNotificationsPlugin().show(
      0,
      'Nouveau message',
      messageText,
      platformDetails,
    );
  }
}
