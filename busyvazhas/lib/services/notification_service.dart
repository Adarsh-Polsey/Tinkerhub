import 'package:busyvazhas/providers/notification_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isSilentMode = false;

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    if (!(await Permission.notification.status.isGranted)) {
      await Permission.notification.request();
    }
    await _notifications.initialize(initializationSettings);
  }

  void setSilentMode(bool value) {
    _isSilentMode = value;
  }

  Future<void> showNotification(
      {required NotificationItem notification}) async {
    if (_isSilentMode) return;
    String? icon;
    if (notification.platform == "WhatsApp") {
      icon = 'wh';
    } else if (notification.platform == "Instagram") {
      icon = 'in';
    } else if (notification.platform == "Telegram") {
      icon = 'te';
    }
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      notification.platform,
      notification.platform,
      icon: icon,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.show(
      DateTime.now().second,
      notification.platform,
      "${notification.sender} ${notification.message}",
      platformChannelSpecifics,
      payload: "",
    );
  }

  Future<void> clearNotifications() async {
    await _notifications.cancelAll();
  }
}
