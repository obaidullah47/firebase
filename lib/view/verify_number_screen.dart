import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyNumberScreen extends StatefulWidget {
  static const String id = 'verifynumberscreen';
  final String verificationId;
  const VerifyNumberScreen({super.key, required this.verificationId});
  @override
  State<VerifyNumberScreen> createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  final TextEditingController _verifycodecontroller = TextEditingController();
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Code")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: _verifycodecontroller,
              decoration: InputDecoration(
                hintText: "6 Digit code",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          RoundButton(
            title: 'Verify',
            onPress: () async {
              setState(() {
                loading = true;
              });
              final creadiantial = PhoneAuthProvider.credential(
                verificationId: widget.verificationId,
                smsCode: _verifycodecontroller.text.toString(),
              );
              try {
                await _auth.signInWithCredential(creadiantial);
                setState(() {
                  loading = false;
                });
              } catch (e) {
                GeneralUtils.flushbar(e.toString(), context);
                setState(() {
                  loading = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
