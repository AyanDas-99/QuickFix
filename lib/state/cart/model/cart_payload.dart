import 'dart:collection';

import 'package:quickfix/state/cart/strings/cart_field_names.dart';

class CartPayload extends MapView<String, dynamic> {
  CartPayload({
    required String name,
    required int price,
    required String productId,
  }) : super({
          CartFieldNames.name: name,
          CartFieldNames.price: price,
          CartFieldNames.productId: productId,
          CartFieldNames.quantity: 1,
        });
}
