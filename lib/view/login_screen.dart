import 'package:firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final ValueNotifier<bool> _eyenotifire = ValueNotifier<bool>(true);
  final _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _eyenotifire.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Login", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: TextFormField(
                    controller: _emailcontroller,

                    decoration: InputDecoration(
                      helperText: "abc@gmail.com",
                      hint: Text("Enter your email"),
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter email";
                      }
                      if (value!.contains("@")) {
                        return "Enter the email that contain @";
                      }
                      return null;
                    },
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _eyenotifire,
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: TextFormField(
                        obscureText: _eyenotifire.value,
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
                          hint: Text("Enter your password"),
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock_open),

                          suffixIcon: InkWell(
                            onTap: () {
                              _eyenotifire.value = !_eyenotifire.value;
                            },
                            child: Icon(
                              _eyenotifire.value
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off,
                            ),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter password";
                          }

                          return null;
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 40),
          Center(
            child: RoundButton(
              title: "Login",
              onPress: () {
                if (_formkey.currentState!.validate()) ;
              },
            ),
          ),
        ],
      ),
    );
  }
}
