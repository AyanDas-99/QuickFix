// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:quickfix/state/user/strings/user_field_names.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? displayName;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final String uid;

  const User(
      {this.displayName,
      required this.email,
      this.phoneNumber,
      this.photoUrl,
      required this.uid});

  @override
  List<Object?> get props => [displayName, email, phoneNumber, photoUrl, uid];

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      displayName: map[UserFieldNames.displayName] != null
          ? map[UserFieldNames.displayName] as String
          : null,
      email: map[UserFieldNames.email] as String,
      phoneNumber: map[UserFieldNames.phoneNumber] != null
          ? map[UserFieldNames.phoneNumber] as String
          : null,
      photoUrl: map[UserFieldNames.photoUrl] != null
          ? map[UserFieldNames.photoUrl] as String
          : null,
      uid: map[UserFieldNames.uid] as String,
    );
  }
}
