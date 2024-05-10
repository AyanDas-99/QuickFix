import 'package:flutter/material.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: Image.asset("assets/logo/quickfix_logo.png"),
          ),
        ),
        title: const Text(
          "QuickFix",
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Icon(
              Icons.signal_wifi_connected_no_internet_4,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
