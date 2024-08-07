// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quickfix/state/cart/strings/cart_field_names.dart';

class CartItem extends Equatable {
  final String name;
  final int price;
  final String productId;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.productId,
    required this.quantity,
  });

  int get subtotal {
    return price * quantity;
  }

  toMap() {
    return {
      CartFieldNames.name: name,
      CartFieldNames.price: price,
      CartFieldNames.productId: productId,
      CartFieldNames.quantity: quantity,
    };
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

  @override
  String toString() {
    return '$name | $price | $quantity';
  }

  @override
  List<Object?> get props => [productId, name, price, quantity];
}
