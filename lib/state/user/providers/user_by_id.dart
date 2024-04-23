import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/user/models/user.dart';
import 'package:quickfix/state/user/strings/user_field_names.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_by_id.g.dart';

// @Riverpod(keepAlive: true)
// Future<User?> userById(UserByIdRef ref, String uid) async {
//   final snapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .where(UserFieldNames.uid, isEqualTo: uid)
//       .limit(1)
//       .get();
//   if (snapshot.docs.isEmpty) {
//     return null;
//   }
//   return User.fromMap(snapshot.docs.first.data());
// }

@Riverpod(keepAlive: true)
Stream<User> userById(UserByIdRef ref, String? uid) {
  final controller = StreamController<User>();

  final sub = FirebaseFirestore.instance
      .collection('users')
      .where(UserFieldNames.uid, isEqualTo: uid)
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    final doc = snapshot.docs.first;
    final map = doc.data();
    final userModel = User.fromMap(map);
    controller.add(userModel);
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
}
