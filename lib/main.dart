import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/firebase_options.dart';
import 'package:quickfix/state/auth/%20repositories/auth_repository.dart';
import 'package:quickfix/state/auth/models/auth_result.dart';
import 'package:quickfix/view/auth/register_screen_controller.dart';
import 'package:quickfix/view/tabs/tab_controller.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // ref.read(currentThemeProvider.notifier).loadInitialTheme();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authRepositoryNotifierProvider);
    // final isLoading = ref.watch(isLoadingProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: QFTheme.theme,
      home: Stack(
        children: [
          if (authState.authResult == AuthResult.success)
            const TabControllerScreen(),
          if (authState.authResult != AuthResult.success)
            const RegisterScreenController(),
        ],
      ),
    );
  }
}