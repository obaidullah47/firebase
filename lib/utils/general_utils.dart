import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GeneralUtils {
  static fluttertoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  static flushbar(String message, BuildContext context) {
    Flushbar(
      message: message,
      title: "Notification",
      duration: Duration(seconds: 1),
      safeArea: true,
      borderRadius: BorderRadius.circular(30),
      backgroundColor: Colors.deepPurple,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(Icons.error, color: Colors.white),
      titleColor: Colors.white,
    ).show(context);
  }
}
