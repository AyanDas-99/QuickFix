import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/cart/model/cart.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart.g.dart';

@Riverpod(keepAlive: true)
Stream<List<CartItem>> cart(CartRef ref) {
  final user = ref.watch(userProvider);
  final controller = StreamController<List<CartItem>>();
  final sub = FirebaseFirestore.instance
      .collection(FirebaseFieldNames.cartsCollection)
      .doc(user!.uid)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.exists) {
      final cartItems = (snapshot.data()!['items'] as List)
          .map((e) => CartItem.fromMap(e))
          .toList();
      controller.sink.add(cartItems);
    } else {
      controller.sink.add([]);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
}
