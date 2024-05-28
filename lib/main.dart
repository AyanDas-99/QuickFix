import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/firebase_options.dart';
import 'package:quickfix/state/auth/%20repositories/auth_repository.dart';
import 'package:quickfix/state/auth/models/auth_result.dart';
import 'package:quickfix/state/providers/scaffold_messenger_key.dart';
import 'package:quickfix/state/utils/check_internet.dart';
import 'package:quickfix/view/auth/register_screen_controller.dart';
import 'package:quickfix/view/tabs/tab_controller.dart';
import 'package:quickfix/view/theme/QFTheme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authRepositoryNotifierProvider);
    ref.watch(checkInternetProvider);

    return MaterialApp(
      scaffoldMessengerKey: ref.watch(scaffoldMessagerKeyProvider),
      debugShowCheckedModeBanner: false,
      title: 'QuickFix',
      theme: QFTheme.theme,
      home: (authState.authResult == AuthResult.success)
          ? const TabControllerScreen()
          : const RegisterScreenController(),
    );
  }
}
