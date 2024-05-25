import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

import 'package:quickfix/state/user/models/user_payload.dart';
import 'package:quickfix/state/user/strings/user_field_names.dart';

class UserStorageRepository {
  final db = FirebaseFirestore.instance;

  Future<bool> storeUserToDb(User user, {String? name}) async {
    try {
      final a = await db
          .collection('users')
          .where(UserFieldNames.phoneNumber, isEqualTo: user.phoneNumber)
          .get();
      if (a.docs.isNotEmpty) {
        return false;
      }

      final payload = UserPayload(
        displayName: user.displayName ?? name,
        uid: user.uid,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );

      await db.collection('users').add(payload);
      return true;
    } catch (e) {
      developer.log("User storage to firestore error", error: e);
    }
    return false;
  }

  static Future<bool> userWithNumberExists(String phoneNumber) async {
    final db = FirebaseFirestore.instance;

    final a = await db
        .collection('users')
        .where(UserFieldNames.phoneNumber, isEqualTo: phoneNumber)
        .get();
    return a.docs.isNotEmpty;
  }
}
