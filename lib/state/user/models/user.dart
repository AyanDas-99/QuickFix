// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:quickfix/state/models/shipping_address.dart';
import 'package:quickfix/state/user/strings/user_field_names.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final String uid;
  final ShippingAddress? shippingAddress;

  const User({
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    required this.uid,
    this.shippingAddress,
  });

  @override
  List<Object?> get props => [displayName, phoneNumber, photoUrl, uid];

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        displayName: map[UserFieldNames.displayName] != null
            ? map[UserFieldNames.displayName] as String
            : null,
        phoneNumber: map[UserFieldNames.phoneNumber] != null
            ? map[UserFieldNames.phoneNumber] as String
            : null,
        photoUrl: map[UserFieldNames.photoUrl] != null
            ? map[UserFieldNames.photoUrl] as String
            : null,
        uid: map[UserFieldNames.uid] as String,
        shippingAddress: (map[UserFieldNames.shippingAddress] == null)
            ? null
            : ShippingAddress.fromMap(
                map[UserFieldNames.shippingAddress] as Map<String, dynamic>));
  }
}
