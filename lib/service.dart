import 'dart:convert';
import 'dart:math';

import 'package:firebase/Notification/message_screen.dart';
import 'package:firebase/utils/general_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      GeneralUtils.fluttertoast("Permission Accepted");
    }
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permisson ');
      }
    }
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      if (kDebugMode) {
        print('User Denied  permission');
      }
    }
  }

  // Changed to initialize once without requiring a message
  Future<void> initializednotification(BuildContext context) async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        // Handle click on local notification
        isIntereact(context);
      },
    );
  }

  void isIntereact(BuildContext context) async {
    RemoteMessage? initialmessage = await firebaseMessaging.getInitialMessage();
    if (initialmessage != null) {
      handlemessage(context, initialmessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handlemessage(context, event);
    });
  }

  void firebasenotificaiton(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        final title = message.notification!.title;
        final body = message.notification!.body;
        print('Notification Title:${title}');
        print('Notification Body:${body}');
        print(message.data.toString());
        print(message.data['type']);
        print(message.data['id']);
      }
      // Fixed: Removed re-initialization here
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
          fullScreenIntent: true,
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
      // Changed: Encode data as JSON for the payload
      payload: jsonEncode(message.data),
      notificationDetails: notificationDetails,
    );
  }

  void refreshtoken() async {
    firebaseMessaging.onTokenRefresh.listen((NewToken) {
      print("New Token ${NewToken}");
    });
  }

  void handlemessage(BuildContext context, RemoteMessage message) {
    _navigate(context, message);
  }

  // Added helper method for navigation
  void _navigate(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'message') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const MessageScreen(),
        ),
      );
    }
  }
}
