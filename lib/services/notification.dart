import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Notification{

  //initialize the flutterlocalnotificationPlugin instance
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  static Future<void> onDidReceiveNotification(NotificationResponse  notificationResponse) async{}

  //initialize the notification plugin
  static Future<void> init() async{
    // DEFINE ANDROID initialisations settings
    const AndroidInitializationSettings androidInitializationSettings =AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings  iOSInitializationSettings = DarwinInitializationSettings();
    const InitializationSettings initializationSettings= InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    //Initialise the plugin with the specificed settings

    await  flutterLocalNotificationsPlugin.initialize(initializationSettings,
 onDidReceiveNotificationResponse: onDidReceiveNotification ,
 onDidReceiveBackgroundNotificationResponse:onDidReceiveNotification ,
    );

    //request notification permission for android
     await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }
  //show an instant Notification
  static Future<void> showInstantNotification(String title, String body) async{
    //define  Notification
    const NotificationDetails plateformChannelSpecifics= NotificationDetails(android:  AndroidNotificationDetails("channel_Id", "channel_Name",importance: Importance.high,priority: Priority.high),
    iOS: DarwinNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.show(0,title ,body, plateformChannelSpecifics);

  }
  //show  a schedule Notification
   //show an instant Notification
  static Future<void> scheduleNotification(String title, String body, DateTime scheduledDate) async{
    //define  Notification
    const NotificationDetails plateformChannelSpecifics= NotificationDetails(android:  AndroidNotificationDetails("channel_Id", "channel_Name",importance: Importance.high,priority: Priority.high),
    iOS: DarwinNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(0, title, body, tz.TZDateTime.from(scheduledDate,tz.local), plateformChannelSpecifics, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );

  }



}