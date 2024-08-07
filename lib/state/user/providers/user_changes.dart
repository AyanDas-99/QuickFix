import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_changes.g.dart';

@riverpod
Stream<User?> userChanges(UserChangesRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}
