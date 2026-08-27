import 'package:firebase/view/home_screen.dart';
import 'package:firebase/view/login_screen.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/general_utils.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'sign_up';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final ValueNotifier<bool> _eyenotifier = ValueNotifier<bool>(true);
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _eyenotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Signup")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                        hintText: "Enter your Email",
                        labelText: "Email",
                        helperText: "abc@gmail.com",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "enter your email";
                        }
                        if (!value.contains('@')) {
                          return "email must contain @";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: _eyenotifier,
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          obscureText: _eyenotifier.value,
                          controller: _passwordcontroller,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_open),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                _eyenotifier.value = !_eyenotifier.value;
                              },
                              child: Icon(
                                _eyenotifier.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "enter your remembered password";
                            }
                            if (!value.contains(RegExp(r'[0-9]'))) {
                              return "password must contain any number 0-9";
                            }
                            return null;
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  RoundButton(
                    title: "Signup",
                    loading: loading,
                    onPress: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        _firebaseAuth
                            .createUserWithEmailAndPassword(
                              email: _emailcontroller.text.toString(),
                              password: _passwordcontroller.text.toString(),
                            )
                            .then((value) {
                              setState(() {
                                loading = false;
                              });
                              // Fix for !_debugLocked: Show toast and delay navigation
                              GeneralUtils.fluttertoast("Signup Successful");
                              Future.delayed(const Duration(seconds: 1), () {
                                if (mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    HomeScreen.id,
                                  );
                                }
                              });
                            })
                            .onError((error, stackTrace) {
                              if (mounted) {
                                GeneralUtils.flushbar(
                                  error.toString(),
                                  context,
                                );
                              }
                              setState(() {
                                loading = false;
                              });
                            });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already had an account ? "),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
