import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:trust_reservation_second/services/local_storage.dart';

import 'api_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification response
      },
    );
  }

  static Future<void> showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', 
      'your_channel_name', 
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  static Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', 
      'your_channel_name', 
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Exemple de méthode utilisant ApiService pour envoyer une notification via l'API
  static Future<void> sendApiNotification(int userId, String title, String body) async {
    Map<String, dynamic> data = {
      'user_id': userId,
      'title': title,
      'body': body,
    };
    await ApiService.sendNotification(data);
  }

  // Exemple de méthode utilisant LocalStorageService pour obtenir des données locales
  static Future<void> showNotificationWithLocalData(int id) async {
    final token = await LocalStorageService.getData('token');
    if (token != null) {
      await showNotification(
        id,
        'Token Notification',
        'Your saved token is: $token',
      );
    } else {
      await showNotification(
        id,
        'Token Notification',
        'No token found in local storage.',
      );
    }
  }
}