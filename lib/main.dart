import 'package:firebase/view/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(firebaseApp());
}

class firebaseApp extends StatelessWidget {
  const firebaseApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(appBarTheme: AppBarThemeData(color: Colors.purple)),
    );
  }
}
