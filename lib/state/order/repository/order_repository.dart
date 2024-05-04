import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/order/models/order_payload.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:quickfix/state/typedefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_repository.g.dart';

@riverpod
class OrderRepository extends _$OrderRepository {
  @override
  IsLoading build() {
    return false;
  }

  //
  Future<bool> buy(List<CartItem> cart) async {
    state = true;
    try {
      state = false;
      return true;
    } catch (e) {
      state = false;
      return false;
    }
  }

  // Add order to firestore after payment completion
  Future<bool> addOrder(OrderPayload orderPayload) async {
    state = true;
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseFieldNames.ordersCollection)
          .add(orderPayload);
      state = false;
      return true;
    } catch (e) {
      state = false;
      return false;
    }
  }
}
