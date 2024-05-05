// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quickfix/state/strings/address_field_names.dart';

class ShippingAddress {
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String houseNo;
  final String landmark;

  ShippingAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.houseNo,
    required this.landmark,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      AddressFieldNames.street: street,
      AddressFieldNames.city: city,
      AddressFieldNames.state: state,
      AddressFieldNames.pincode: pincode,
      AddressFieldNames.houseNo: houseNo,
      AddressFieldNames.landmark: landmark,
    };
  }

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      street: map[AddressFieldNames.street] as String,
      city: map[AddressFieldNames.city] as String,
      state: map[AddressFieldNames.state] as String,
      pincode: map[AddressFieldNames.pincode] as String,
      houseNo: map[AddressFieldNames.houseNo] as String,
      landmark: map[AddressFieldNames.landmark] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShippingAddress.fromJson(String source) =>
      ShippingAddress.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '$houseNo, $landmark, $street, $city, $state, $pincode';
  }
}
