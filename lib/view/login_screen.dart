import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/view/home_screen.dart';
import 'package:firebase/view/signup_screen.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final ValueNotifier<bool> _eyenotifier = ValueNotifier<bool>(true);
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool loading = false;

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
          email: _emailcontroller.text.toString(),
          password: _passwordcontroller.text.toString(),
        )
        .then((value) {
          setState(() {
            loading = false;
          });
          GeneralUtils.flushbar(value.user!.email.toString(), context);
          Future.delayed(Duration(seconds: 2));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          GeneralUtils.flushbar("Login successfulllyyyy", context);
        })
        .onError((error, stackTrace) {
          GeneralUtils.flushbar(error.toString(), context);
          setState(() {
            loading = false;
          });
        });
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _eyenotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
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
                  title: "Login",
                  loading: loading,
                  onPress: () {
                    if (_formkey.currentState!.validate()) {
                      login();

                      // Login logic here
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Didn't had an account"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Signup",
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
    );
  }
}
