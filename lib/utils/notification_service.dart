import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
      },
    );
  }

  static Future<void> showSpeedTestCompleteNotification({
    required double downloadSpeed,
    required double uploadSpeed,
    required double ping,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'speed_test_channel',
      'Speed Test Results',
      channelDescription: 'Notifications for speed test completion',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      0, // Notification ID
      'Speed Test Complete! 🚀',
      'Download: ${downloadSpeed.toStringAsFixed(2)} Mbps\n'
      'Upload: ${uploadSpeed.toStringAsFixed(2)} Mbps\n'
      'Ping: ${ping.toStringAsFixed(0)} ms',
      platformChannelSpecifics,
    );
  }

  static Future<void> showDownloadCompleteNotification({
    required double downloadSpeed,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'speed_test_channel',
      'Speed Test Results',
      channelDescription: 'Notifications for speed test completion',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      1, // Notification ID
      'Download Test Complete! ⬇️',
      'Download Speed: ${downloadSpeed.toStringAsFixed(2)} Mbps',
      platformChannelSpecifics,
    );
  }

  static Future<void> showUploadCompleteNotification({
    required double uploadSpeed,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'speed_test_channel',
      'Speed Test Results',
      channelDescription: 'Notifications for speed test completion',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      2, // Notification ID
      'Upload Test Complete! ⬆️',
      'Upload Speed: ${uploadSpeed.toStringAsFixed(2)} Mbps',
      platformChannelSpecifics,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
} 