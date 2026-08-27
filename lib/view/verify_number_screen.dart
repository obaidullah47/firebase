import 'package:flutter/material.dart';

class VerifyNumberScreen extends StatefulWidget {
  final String verificationId;
  const VerifyNumberScreen({super.key, required this.verificationId});

  @override
  State<VerifyNumberScreen> createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar());
  }
}
