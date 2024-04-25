import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';

class LoginSecurityPage extends ConsumerStatefulWidget {
  const LoginSecurityPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginSecurityPageState();
}

class _LoginSecurityPageState extends ConsumerState<LoginSecurityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(false, context: context, canGoBack: true),
      body: Column(
        children: [
          Text("Login & Security"),
          TextField(
            decoration: InputDecoration(hintText: "Name"),
          )
        ],
      ),
    );
  }
}
