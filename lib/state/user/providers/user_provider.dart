import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
User? user(UserRef ref) {
  final authUser = FirebaseAuth.instance.currentUser;
  return authUser;
}
