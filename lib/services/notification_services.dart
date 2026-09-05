import 'dart:math';

import 'package:firebase/utils/general_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FirebaseMessaging _message = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestnotificaionservices() async {
    NotificationSettings settings = await _message.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      provisional: true,
      criticalAlert: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      GeneralUtils.fluttertoast("User Granted Permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      GeneralUtils.fluttertoast("User Granted Provisional permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      GeneralUtils.fluttertoast("User Denied Permission");
    }
  }

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        print("Notification tapped: ${response.payload}");
      },
    );
  }

  Future<String?> getdeviceToken() async {
    String? token = await _message.getToken();
    return token;
  }

  void firebasenotification() async {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        final title = message.notification?.title ?? "Notification";
        final body = message.notification?.body ?? "Body";
        print("Notification Title: $title");
        print("Notification Body: $body");
      }
      shownotification(message);
    });
  }

  Future<void> shownotification(RemoteMessage message) async {
    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
        );

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    int notifyId = Random().nextInt(100000);

    await _flutterLocalNotificationsPlugin.show(
      id: notifyId,
      title: message.notification?.title ?? "New Message",
      body: message.notification?.body ?? "You have a new message",
      notificationDetails: notificationDetails,
    );
  }

  void isTokenRefresh() async {
    _message.onTokenRefresh.listen((newToken) {
      print('New Token : ${newToken.toString()}');
    });
  }
}
