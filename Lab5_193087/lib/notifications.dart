import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() { return _notificationService; }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  NotificationService._internal();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('icon');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> show(int id, String title, String body, int seconds)  async {
    await flutterLocalNotificationsPlugin.show(id, title, body,
        const NotificationDetails(android: AndroidNotificationDetails('main_channel', 'Main Channel', importance: Importance.max, priority: Priority.max)
          ,), payload: "data");
  }
}