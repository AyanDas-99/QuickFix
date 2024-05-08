// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/models/shipping_address.dart';
import 'package:quickfix/state/order/models/order_status.dart';
import 'package:quickfix/state/order/strings/order_field_names.dart';

class Order {
  final String id;
  final String userId;
  final DateTime timestamp;
  final OrderStatus orderStatus;
  final int price;
  final bool isCashOnDelivery;
  final ShippingAddress shippingAddress;
  final List<CartItem> items;
  final String? orderId;

  Order({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.orderStatus,
    required this.price,
    required this.isCashOnDelivery,
    required this.shippingAddress,
    required this.items,
    required this.orderId,
  });

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'userId': userId,
  //     'timestamp': timestamp,
  //     'orderStatus': orderStatus.toMap(),
  //     'price': price,
  //     'isCashOnDelivery': isCashOnDelivery,
  //     'shippingAddress': shippingAddress.toMap(),
  //     'items': items.map((x) => x.toMap()).toList(),
  //   };
  // }

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      userId: map[OrderFieldNames.userId] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          (map[OrderFieldNames.timestamp] as Timestamp).millisecondsSinceEpoch),
      orderStatus: OrderStatus.values.firstWhere((element) =>
          element.name == (map[OrderFieldNames.orderStatus] as String)),
      price: map[OrderFieldNames.price] as int,
      isCashOnDelivery: map[OrderFieldNames.isCashOnDelivery] as bool,
      shippingAddress: ShippingAddress.fromMap(
          map[OrderFieldNames.shippingAddress] as Map<String, dynamic>),
      items: List<CartItem>.from(
        (map[OrderFieldNames.items] as List).map<CartItem>(
          (x) => CartItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      orderId: map[OrderFieldNames.orderId],
    );
  }

  // String toJson() => json.encode(toMap());

  factory Order.fromJson(String source, String id) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>, id);
}
