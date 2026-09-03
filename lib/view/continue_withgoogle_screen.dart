import 'package:firebase/firestore/firestore_homescreen.dart';
import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ContinueWithgoogleScreen extends StatefulWidget {
  static const String id = 'continuewithgoogle';
  const ContinueWithgoogleScreen({super.key});

  @override
  State<ContinueWithgoogleScreen> createState() =>
      _ContinueWithgoogleScreenState();
}

class _ContinueWithgoogleScreenState extends State<ContinueWithgoogleScreen> {
  bool loading = false;
  Future<void> handlesignIn() async {
    setState(() {
      loading = true;
    });
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '173588200499-3ku21qebcois077u308ic3ihphsr0k3a.apps.googleusercontent.com',
      );
      final GoogleSignInAccount _googleuser = await GoogleSignIn.instance
          .authenticate();
      final GoogleSignInAuthentication _googleauth = _googleuser.authentication;
      final creadiential = GoogleAuthProvider.credential(
        idToken: _googleauth.idToken,
      );
      final UserCredential _usercredential = await FirebaseAuth.instance
          .signInWithCredential(creadiential);
      GeneralUtils.fluttertoast(
        'UserName:${_usercredential.user!.displayName}\nEmail:${_usercredential.user!.email}',
      );
      Navigator.pushReplacementNamed(context, FirestoreHomescreen.id);
    } catch (e) {
      GeneralUtils.flushbar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Continue with Google")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: RoundButton(
              title: "Continue with Google",
              onPress: () {
                handlesignIn();
              },
            ),
          ),
        ],
      ),
    );
  }
}
