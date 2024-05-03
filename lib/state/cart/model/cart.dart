// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quickfix/state/cart/strings/cart_field_names.dart';

class CartItem {
  final String name;
  final int price;
  final String productId;
  final int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.productId,
    required this.quantity,
  });

  int get subtotal {
    return price * quantity;
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      name: map[CartFieldNames.name] as String,
      price: map[CartFieldNames.price] as int,
      productId: map[CartFieldNames.productId] as String,
      quantity: map[CartFieldNames.quantity] as int,
    );
  }

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
