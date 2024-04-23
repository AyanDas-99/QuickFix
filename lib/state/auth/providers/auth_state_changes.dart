import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// final authStateProvider = StreamProvider<User?>((ref) {
//   return ref.read(authRepositoryNotifierProvider.notifier).authStateChange;
// });
part 'auth_state_changes.g.dart';

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}
