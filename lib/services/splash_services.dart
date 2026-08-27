import 'dart:async';

import 'package:firebase/view/home_screen.dart';
import 'package:firebase/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void islogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    if (user != null) {
      Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        ),
      );
    } else {
      Timer(
        Duration(seconds: 3),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
      );
    }
  }
}
