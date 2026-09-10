import 'package:firebase/firestore/firestore_homescreen.dart';
import 'package:firebase/service.dart';
import 'package:firebase/view/continue_withgoogle_screen.dart';
import 'package:firebase/view/home_screen.dart';
import 'package:firebase/view/login_screen.dart';
import 'package:firebase/view/signup_screen.dart';
import 'package:firebase/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Create a global Service instance (initialized once)
final service = Service();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(Firebasebackgroundmessaginghandler);
  await Firebase.initializeApp();
  service.ShowNotification(RemoteMessage());

  runApp(const FirebaseApp());
}

@pragma('vm:entry-point')
Future<void> Firebasebackgroundmessaginghandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.notification!.title}');
}

class FirebaseApp extends StatefulWidget {
  const FirebaseApp({super.key});

  @override
  State<FirebaseApp> createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  @override
  void initState() {
    super.initState();
    _setupNotifications(RemoteMessage());
  }

  Future<void> _setupNotifications(RemoteMessage message) async {
    // Initialize local notifications first (no context needed)
    await service.initializednotification(context);

    // Then request permission
    service.ReqNotificationService();

    // Get device token
    String? token = await service.getDeviceToken();
    print('FCM Token: $token');

    // Setup message listeners (pass context here where it's available)
    service.isIntereact(context);
    service.firebasenotificaiton(context);
    await service.ShowNotification(message);
    // Listen for token refresh
    service.refreshtoken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignupScreen.id: (context) => const SignupScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ContinueWithgoogleScreen.id: (context) =>
            const ContinueWithgoogleScreen(),
        FirestoreHomescreen.id: (context) => const FirestoreHomescreen(),
      },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          centerTitle: true,
        ),
      ),
    );
  }
}
