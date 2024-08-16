// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'api_service.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         // Handle notification response
//       },
//     );
//   }

//   static Future<void> showNotification(int id, String title, String body,
//       {String? icon}) async {
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       channelDescription: 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//       largeIcon: icon != null ? DrawableResourceAndroidBitmap(icon) : null,
//       styleInformation: const BigTextStyleInformation(''),
//     );

//     final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       id,
//       title,
//       body,
//       platformChannelSpecifics,
//     );
//   }

//   static Future<void> scheduleNotification(
//       int id, String title, String body, DateTime scheduledTime,
//       {String? icon}) async {
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       channelDescription: 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//       largeIcon: icon != null ? DrawableResourceAndroidBitmap(icon) : null,
//       styleInformation: const BigTextStyleInformation(''),
//     );

//     final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       platformChannelSpecifics,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.wallClockTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   static Future<void> sendApiNotification(int userId, String title, String body,
//       {String? icon}) async {
//     Map<String, dynamic> data = {
//       'userId': userId,
//       'title': title,
//       'body': body,
//       'icon': icon,
//     };
//     await ApiService().postData('/notifications', data);
//   }
// }
