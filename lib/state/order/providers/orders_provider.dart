import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/order/models/order.dart' as order_model;
import 'package:quickfix/state/order/strings/order_field_names.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'orders_provider.g.dart';

@riverpod
Stream<Iterable<order_model.Order>> orders(OrdersRef ref) {
  final user = ref.watch(userProvider);

  final controller = StreamController<Iterable<order_model.Order>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseFieldNames.ordersCollection)
      .where(OrderFieldNames.userId, isEqualTo: user!.uid)
      .snapshots()
      .listen((snapshot) {
    final orders =
        snapshot.docs.map((e) => order_model.Order.fromMap(e.data(), e.id));
    controller.sink.add(orders);
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
}
