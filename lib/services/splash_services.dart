import 'dart:async';

import 'package:firebase/view/login_screen.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void islogin(BuildContext context) {
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      ),
    );
  }
}
