import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> iniNotification() async {
    const AndroidInitializationSettings android_initializationSettings =
        AndroidInitializationSettings('@drawable/ic_unnayan_notification_icon');

    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: android_initializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotificaiton(
      int id, String title, String body, int seconds, bool groupBool) async {
    await _configureLocalTimeZone();
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     id,
    //     title,
    //     body,
    //     tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
    //     NotificationDetails(
    //         android: AndroidNotificationDetails('main_channel', 'Main Channel',
    //             channelDescription: 'Main channel notification',
    //             importance: Importance.max,
    //             priority: Priority.max,
    //             groupKey: 'com.android.example.unnayan',
    //             setAsGroupSummary: groupBool,
    //             icon: '@drawable/ic_unnayan_notification_icon')),
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     androidAllowWhileIdle: true);

    const AndroidNotificationDetails firstNotificationAndroidSpecifics =
        AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: 'Main channel notification',
      importance: Importance.max,
      priority: Priority.high,
      groupKey: 'com.android.example.unnayan',
    );
    const NotificationDetails firstNotificationPlatformSpecifics =
        NotificationDetails(android: firstNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, firstNotificationPlatformSpecifics);
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
  }
}
