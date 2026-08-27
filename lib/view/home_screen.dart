import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "homescreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _auth
                  .signOut()
                  .then((value) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginScreen.id,
                      (route) => false,
                    );

                    GeneralUtils.flushbar("sign out", context);
                  })
                  .onError((error, stackTrace) {
                    if (kDebugMode) {
                      print(error.toString());
                    }
                    GeneralUtils.flushbar(error.toString(), context);
                  });
            },
            icon: Icon(Icons.login, color: Colors.white),
          ),
          SizedBox(width: 10),
        ],

        title: Text("HomeScreen"),
      ),
    );
  }
}
