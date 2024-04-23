import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

import 'package:quickfix/state/user/models/user_payload.dart';

class UserStorageRepository {
  final db = FirebaseFirestore.instance;

  Future<bool> storeUserToDb(User user) async {
    try {
      final a = await db
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();
      if (a.docs.isNotEmpty) {
        return false;
      }

      final payload = UserPayload(
          displayName: user.displayName,
          email: user.email,
          uid: user.uid,
          photoUrl: user.photoURL,
          phoneNumber: user.phoneNumber);

      await db.collection('users').add(payload);
      return true;
    } catch (e) {
      developer.log("User storage to firestore error", error: e);
    }
    return false;
  }
}
