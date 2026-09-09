import 'package:firebase/firestore/firestore_homescreen.dart';
import 'package:firebase/service.dart';
// import 'package:firebase/services/notification_services.dart';
import 'package:firebase/view/continue_withgoogle_screen.dart';
import 'package:firebase/view/home_screen.dart';
import 'package:firebase/view/login_screen.dart';
import 'package:firebase/view/signup_screen.dart';
import 'package:firebase/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(Firebasebackgroundmessaginghandler);
  // Initialize Firebase first
  await Firebase.initializeApp();

  // Initialize notifications second
  await Service().initializednotification();

  runApp(const FirebaseApp());
}

//this pragma parameter is used to show the notificatio in background when the app is killed without this notification cannot be shown
//this code from lineno 27 to 30 is mainly used for background notification
@pragma('vm:entry-point')
Future<void> Firebasebackgroundmessaginghandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}

class FirebaseApp extends StatelessWidget {
  const FirebaseApp({super.key});

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
