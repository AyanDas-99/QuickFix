import 'package:quickfix/view/auth/login_with_phone.dart';
import 'package:quickfix/view/auth/signup_with_phone.dart';
import 'package:flutter/material.dart';

class RegisterScreenController extends StatefulWidget {
  const RegisterScreenController({super.key});

  @override
  State<RegisterScreenController> createState() =>
      _RegisterScreenControllerState();
}

class _RegisterScreenControllerState extends State<RegisterScreenController> {
  bool loggin = true;

  void onClick() {
    setState(() {
      loggin = !loggin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loggin) {
      return LoginWithPhone(onClick: onClick);
    }
    return SignUpWithPhone(onClick: onClick);
  }
}
