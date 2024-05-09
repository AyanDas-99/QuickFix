// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quickfix/state/auth/%20repositories/auth_repository.dart';
import 'package:quickfix/state/providers/scaffold_messenger.dart';
import 'package:quickfix/view/auth/otp_screen.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class LoginWithPhone extends ConsumerStatefulWidget {
  final VoidCallback onClick;
  const LoginWithPhone({super.key, required this.onClick});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends ConsumerState<LoginWithPhone> {
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  int? resentToken;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  void onLogin() {
    if (_formKey.currentState!.validate()) {
      ref.read(authRepositoryNotifierProvider.notifier).phoneSignUp(
            resendToken: resentToken,
            phoneNumber: '+91${phoneNumberController.text}',
            showMessage: (String text) {
              ref
                  .read(scaffoldMessengerProvider)
                  .showSnackBar(SnackBar(content: Text(text)));
            },
            codeSent: (String id, int? token) async {
              resentToken = token;
              print(resentToken);
              print(token);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OTPScreen(
                  verificationId: id,
                  resendToken: resentToken,
                  phoneNumber: '+91${phoneNumberController.text}',
                ),
              ));
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        authRepositoryNotifierProvider.select((value) => value.isLoading));

    return Scaffold(
      body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 70,
                        child: Image.asset("assets/logo/quickfix_logo.png"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Welcome back to QuickFix",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      focusNode: _phoneFocusNode,
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(10),
                          hintText: "Phone number",
                          prefixIcon: const Icon(Icons.phone),
                          prefixIconColor: Colors.grey,
                          filled: true,
                          prefixText: _phoneFocusNode.hasFocus ? '+91 ' : null),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length != 10) {
                          return 'Your number is not valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    MainButton(
                      onPressed: (isLoading) ? () {} : onLogin,
                      backgroundColor: (isLoading)
                          ? Colors.green.shade300
                          : QFTheme.mainGreen,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    const SizedBox(height: 15),
                    MainButton(
                        onPressed: isLoading ? () {} : widget.onClick,
                        backgroundColor: Colors.white54,
                        child: const Text("I don't have an account")),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
