import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/models/shipping_address.dart';
import 'package:quickfix/state/order/models/order_status.dart';
import 'package:quickfix/state/order/strings/order_field_names.dart';

class OrderPayload extends MapView<String, dynamic> {
  OrderPayload({
    required String userId,
    required int price,
    required bool isCashOnDelivery,
    required ShippingAddress shippingAddress,
    required List<CartItem> items,
  }) : super({
          OrderFieldNames.userId: userId,
          OrderFieldNames.timestamp: FieldValue.serverTimestamp(),
          OrderFieldNames.orderStatus: OrderStatus.pending.name,
          OrderFieldNames.price: price,
          OrderFieldNames.isCashOnDelivery: isCashOnDelivery,
          OrderFieldNames.shippingAddress: shippingAddress.toMap(),
          OrderFieldNames.items: items.map((e) => e.toMap()).toList(),
        });
}
