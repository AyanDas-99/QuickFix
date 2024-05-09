import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/order/models/order_status.dart';
import 'package:quickfix/state/order/strings/order_field_names.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:quickfix/state/typedefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_order.g.dart';

@riverpod
class UpdateOrder extends _$UpdateOrder {
  @override
  IsLoading build() {
    return false;
  }

  Future<bool> updateOrderStatus(
      {required orderId, required OrderStatus orderStatus}) async {
    state = true;
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseFieldNames.ordersCollection)
          .doc(orderId)
          .update({OrderFieldNames.orderStatus: orderStatus.name});
      state = false;
      return true;
    } catch (e) {
      state = false;
      return false;
    }
  }
}
