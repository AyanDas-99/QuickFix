import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quickfix/state/auth/%20repositories/auth_repository.dart';
import 'package:quickfix/view/auth/otp_screen.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class SignUpWithPhone extends ConsumerStatefulWidget {
  final VoidCallback onClick;
  const SignUpWithPhone({super.key, required this.onClick});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignUpWithPhoneState();
}

class _SignUpWithPhoneState extends ConsumerState<SignUpWithPhone> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  int? resendToken;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void onLogin() {
    if (_formKey.currentState!.validate()) {
      ref.read(authRepositoryNotifierProvider.notifier).phoneSignUp(
            phoneNumber: '+91${phoneNumberController.text}',
            name: nameController.text,
            resendToken: resendToken,
            showMessage: (String text) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(text)));
            },
            codeSent: (String id, int? token) {
              resendToken = token;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OTPScreen(
                  phoneNumber: '+91${phoneNumberController.text}',
                  verificationId: id,
                  name: nameController.text,
                ),
              ));
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authRepositoryNotifierProvider).isLoading;

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
                      "Welcome to QuickFix",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Full Name",
                        prefixIcon: Icon(Icons.email),
                        prefixIconColor: Colors.grey,
                        filled: true,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      focusNode: _phoneFocusNode,
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Phone number",
                          prefixIcon: Icon(Icons.phone),
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
                      onPressed: isLoading ? () {} : onLogin,
                      backgroundColor:
                          isLoading ? Colors.green.shade300 : QFTheme.mainGreen,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    const SizedBox(height: 15),
                    MainButton(
                      onPressed: widget.onClick,
                      backgroundColor: Colors.white54,
                      child: const Text("Already have an account"),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
