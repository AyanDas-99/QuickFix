// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:quickfix/state/auth/%20repositories/auth_repository.dart';

class LoginWithPhone extends ConsumerStatefulWidget {
  const LoginWithPhone({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends ConsumerState<LoginWithPhone> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool otpSent = false;
  String? verificationId;

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: SizedBox(
                      height: 70,
                      // child: Image.asset("assets/icon/logo.png"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Welcome Back",
                    style: Theme.of(context).textTheme.headlineMedium,
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
                        return 'Please enter your full';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Phone number",
                      prefixIcon: Icon(Icons.key),
                      prefixIconColor: Colors.grey,
                      filled: true,
                    ),
                    // The validator receives the text that the user has entered.
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref
                            .read(authRepositoryNotifierProvider.notifier)
                            .phoneSignUp(
                              phoneNumber: phoneNumberController.text,
                              showMessage: (String text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(text)));
                              },
                              codeSent: (id) {
                                verificationId = id;
                                print("Code sent from ui");
                                setState(() {
                                  otpSent = true;
                                });
                              },
                            );
                      }
                    },
                    child: const Text(
                      'Get OTP',
                    ),
                  ),

                  // Otp section
                  if (otpSent && verificationId != null)
                    OtpSection(verificationId: verificationId!)
                ],
              ),
            ),
          )),
    );
  }
}

class OtpSection extends ConsumerStatefulWidget {
  final String verificationId;
  const OtpSection({
    super.key,
    required this.verificationId,
  });

  @override
  ConsumerState<OtpSection> createState() => _OtpSectionState();
}

class _OtpSectionState extends ConsumerState<OtpSection> {
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: otpController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10),
            hintText: "OTP",
            prefixIcon: Icon(Icons.key),
            prefixIconColor: Colors.grey,
            filled: true,
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        TextButton(
          onPressed: () {
            ref.read(authRepositoryNotifierProvider.notifier).checkOTP(
                verificationId: widget.verificationId, otp: otpController.text);
          },
          child: const Text(
            'Check OTP',
          ),
        ),
      ],
    );
  }
}
