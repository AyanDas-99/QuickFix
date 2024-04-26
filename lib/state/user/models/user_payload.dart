// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:quickfix/state/user/strings/user_field_names.dart';

@immutable
class UserPayload extends MapView<String, dynamic> {
  UserPayload({
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    String? uid,
  }) : super({
          UserFieldNames.displayName: displayName,
          UserFieldNames.phoneNumber: phoneNumber,
          UserFieldNames.photoUrl: photoUrl,
          UserFieldNames.uid: uid,
        });
}
