import 'package:firebase/service.dart';
import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/view/forgot_password_screen.dart';
import 'package:firebase/view/home_screen.dart';
import 'package:firebase/view/phone_number_screen.dart';
import 'package:firebase/view/signup_screen.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'continue_withgoogle_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final NotificationServices _notificationServices = NotificationServices();
  final Service _service = Service();
  @override
  void initState() {
    super.initState();
    _service.ReqNotificationService();
    _service.initializednotification();
    _service.isIntereact(context);
    _service.firebasenotificaiton();
    _service.getDeviceToken();
  }

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

          // Using pushNamedAndRemoveUntil to clear stack
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.id,
            (route) => false,
          );
          GeneralUtils.fluttertoast("Login successfully");
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
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
                                return null;
                              },
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text("Forgot Password"),
                          ),
                        ),
                      ),
                      RoundButton(
                        title: "Login",
                        loading: loading,
                        onPress: () {
                          if (_formkey.currentState!.validate()) {
                            login();
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Didn't have an account"),
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PhoneNumberScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.deepPurple,
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Login with Phone number",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ContinueWithgoogleScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.deepPurpleAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.g_mobiledata),
                                const SizedBox(width: 5),
                                const Text(
                                  "Continue with Google",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
