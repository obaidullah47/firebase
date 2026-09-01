import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String id = 'forgotpasswordscreen';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool loading = false;
  final _emailcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailcontroller,
              decoration: InputDecoration(
                hintText: "Enter your Email",
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 50),
            RoundButton(
              loading: loading,
              title: "Forgot Password",
              onPress: () {
                setState(() {
                  loading = true;
                });
                auth
                    .sendPasswordResetEmail(
                      email: _emailcontroller.text.toString(),
                    )
                    .then((value) {
                      setState(() {
                        loading = false;
                      });
                      GeneralUtils.flushbar(
                        "We send you a reset link on your email to recover your password",
                        context,
                      );
                    })
                    .onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      GeneralUtils.fluttertoast(error.toString());
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
