import 'package:quickfix/view/auth/login_screen.dart';
import 'package:quickfix/view/auth/login_with_phone.dart';
import 'package:quickfix/view/auth/sign_up_screen.dart';
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
    // return LoginWithPhone();
    if (loggin) {
      return LoginScreen(onClick);
    }
    return SignUpScreen(onClick);
  }
}
