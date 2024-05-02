import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/product/models/product.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_products.g.dart';

@Riverpod(keepAlive: true)
Stream<Iterable<Product>> allProducts(AllProductsRef ref) {
  final controller = StreamController<Iterable<Product>>();
  final sub = FirebaseFirestore.instance
      .collection(FirebaseFieldNames.productsCollection)
      .snapshots()
      .listen((snapshots) {
    final products = snapshots.docs
        .where((element) => !element.metadata.hasPendingWrites)
        .map((e) => Product.fromMap(e.data(), e.id));

    controller.sink.add(products);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
}
