import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/view/verify_number_screen.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneNumberScreen extends StatefulWidget {
  static const String id = 'phonenumberscreen';
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  final phonenumbercontroller = TextEditingController();
  void dispose() {
    phonenumbercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone number')),
      body: Column(
        children: [
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              controller: phonenumbercontroller,
              decoration: InputDecoration(
                hintText: "+1 234 3249102",
                helperText: "Enter your phone number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(height: 80),
          RoundButton(
            loading: loading,
            title: "Verify",
            onPress: () {
              setState(() {
                loading = true;
              });
              _auth.verifyPhoneNumber(
                verificationCompleted: (_) {
                  setState(() {
                    loading = false;
                  });
                },
                verificationFailed: (e) {
                  GeneralUtils.flushbar(e.toString(), context);
                  setState(() {
                    loading = false;
                  });
                },

                codeSent: (String verification, int? token) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VerifyNumberScreen(verificationId: verification),
                    ),
                  );
                  setState(() {
                    loading = false;
                  });
                },
                codeAutoRetrievalTimeout: (e) {
                  GeneralUtils.flushbar(e.toString(), context);
                  setState(() {
                    loading = false;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
