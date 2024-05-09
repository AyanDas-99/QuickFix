import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/auth/%20repositories/auth_repository.dart';
import 'package:quickfix/state/providers/scaffold_messenger.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/theme/QFTheme.dart';
import 'dart:developer' as dev;

class OTPScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String? name;
  final int? resendToken;
  final String phoneNumber;
  const OTPScreen({
    super.key,
    required this.verificationId,
    this.name,
    this.resendToken,
    required this.phoneNumber,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final code1 = TextEditingController();
  final code2 = TextEditingController();
  final code3 = TextEditingController();
  final code4 = TextEditingController();
  final code5 = TextEditingController();
  final code6 = TextEditingController();

  String error = '';

  showMessage(String text) {
    ref
        .read(scaffoldMessengerProvider)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  checkOtp() async {
    if (code1.text.isEmpty ||
        code2.text.isEmpty ||
        code3.text.isEmpty ||
        code4.text.isEmpty ||
        code5.text.isEmpty ||
        code6.text.isEmpty) {
      dev.log('No full otp');
      setState(() {
        error = "Enter complete OTP";
      });
    } else {
      final otp =
          "${code1.text}${code2.text}${code3.text}${code4.text}${code5.text}${code6.text}";
      print(otp);
      final done = await ref
          .read(authRepositoryNotifierProvider.notifier)
          .checkOTP(
              verificationId: widget.verificationId,
              otp: otp,
              name: widget.name,
              showMessage: showMessage);
      if (done) {
        Navigator.of(context).maybePop();
      }
    }
  }

  late Timer timer;
  int start = 120;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  String toMinute(int seconds) {
    final int min = (seconds / 60).floor();
    final int secs = seconds - (min * 60);
    return '$min : $secs';
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    code1.dispose();
    code2.dispose();
    code3.dispose();
    code4.dispose();
    code5.dispose();
    code6.dispose();
  }

  void resendOtp() {
    if (start == 0) {
      ref.read(authRepositoryNotifierProvider.notifier).phoneSignUp(
            phoneNumber: widget.phoneNumber,
            showMessage: (String text) {
              ref
                  .read(scaffoldMessengerProvider)
                  .showSnackBar(SnackBar(content: Text(text)));
            },
            codeSent: (String id, int? token) async {
              print(token);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => OTPScreen(
                  verificationId: id,
                  resendToken: token,
                  phoneNumber: widget.phoneNumber,
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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Verification Code",
              style: TextStyle(fontSize: 30),
            ),
            const Text(
              "A verification code has been sent to your mobile number",
            ),
            if (error.isNotEmpty)
              Text(
                error,
                style: TextStyle(color: Colors.red.shade900),
              ),
            const SizedBox(height: 30),
            Form(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: TextFormField(
                          autofocus: true,
                          controller: code1,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                          ),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: TextFormField(
                          controller: code2,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                          ),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: TextFormField(
                          controller: code3,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                          ),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: TextFormField(
                          controller: code4,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                          ),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: TextFormField(
                          controller: code5,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                          ),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: TextFormField(
                          controller: code6,
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                          ),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(toMinute(start)),
                  const SizedBox(
                    height: 30,
                  ),
                  MainButton(
                    onPressed: isLoading
                        ? () {}
                        : (start != 0)
                            ? checkOtp
                            : resendOtp,
                    backgroundColor:
                        isLoading ? Colors.green.shade300 : QFTheme.mainGreen,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            (start == 0) ? "Resend OTP" : "Submit",
                            style: const TextStyle(color: Colors.white),
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
