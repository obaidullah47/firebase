import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Service {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<String?> getDeviceToken() async {
    String? token = await firebaseMessaging.getToken();
    return token;
  }

  void ReqNotificationService() async {
    NotificationSettings notificationSettings = await firebaseMessaging
        .requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: true,
          provisional: true,
          criticalAlert: true,
          sound: true,
        );
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print("Permession accepted");
    }
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permisson ');
    }
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      print('User Denied  permission');
    }
  }

  Future<void> initializednotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (kDebugMode) {
          print('Notification Tapped${response.payload}');
        }
      },
    );
  }

  void firebasenotificaiton() async {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        final title = message.notification!.title;
        final body = message.notification!.body;
        print('Notification Title:${title}');
        print('Notification Body:${body}');
      }
      ShowNotification(message);
    });
  }

  Future<void> ShowNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
          'high importance channel',
          'high importance Notifications',
          importance: Importance.max,
        );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          androidNotificationChannel.id,
          androidNotificationChannel.name,
          channelDescription: 'This is your channel',
          ticker: 'ticker',
          importance: Importance.high,
          priority: Priority.high,
        );
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentSound: true,
          presentBadge: true,
          presentAlert: true,
        );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    final uniqueid = Random().nextInt(1000);
    await flutterLocalNotificationsPlugin.show(
      id: uniqueid,
      title: message.notification!.title ?? "New message",
      body: message.notification!.body ?? '',
      notificationDetails: notificationDetails,
    );
  }

  void refreshtoken() async {
    firebaseMessaging.onTokenRefresh.listen((NewToken) {});
  }
}
