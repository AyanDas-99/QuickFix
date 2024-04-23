import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/auth/%20repositories/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen(this.onClick, {super.key});
  final VoidCallback onClick;
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        authRepositoryNotifierProvider.select((value) => value.isLoading));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
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
                    controller: emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                      prefixIconColor: Colors.grey,
                      filled: true,
                      fillColor: Colors.grey.shade900,
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(10),
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.key),
                      prefixIconColor: Colors.grey,
                      suffix: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => setState(() {
                          showPassword = !showPassword;
                        }),
                        icon: FaIcon(
                          showPassword
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          size: 15,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 8) {
                        return 'Password should be atleast 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ref
                            .read(authRepositoryNotifierProvider.notifier)
                            .emailLogin(
                                email: emailController.text,
                                password: passwordController.text);
                      }
                    },
                    child: const Text(
                      'Log in',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Or', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 20),
                  TextButton(
                    style: Theme.of(context).textButtonTheme.style?.copyWith(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blue.shade600)),
                    onPressed: () {
                      ref
                          .read(authRepositoryNotifierProvider.notifier)
                          .googleLogin();
                    },
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.google),
                              SizedBox(width: 10),
                              Text(
                                'Sign in with Google',
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 40),
                  RichText(
                    text: TextSpan(
                      text: 'Not registered yet?  ',
                      children: [
                        TextSpan(
                            text: 'Create account',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClick),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
