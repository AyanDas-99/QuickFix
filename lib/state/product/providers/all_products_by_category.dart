import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/product/models/product.dart';
import 'package:quickfix/state/product/providers/category.dart';
import 'package:quickfix/state/product/strings/product_field_names.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_products_by_category.g.dart';

@Riverpod(keepAlive: true)
Stream<Iterable<Product>> allProductsByCategory(AllProductsByCategoryRef ref) {
  final controller = StreamController<Iterable<Product>>();
  final category = ref.watch(categoryProvider);

  final sub = (category == 'All')
      ? FirebaseFirestore.instance
          .collection(FirebaseFieldNames.productsCollection)
          .snapshots()
          .listen((snapshots) {
          final products = snapshots.docs
              .where((element) => !element.metadata.hasPendingWrites)
              .map((e) => Product.fromMap(e.data(), e.id));

          controller.sink.add(products);
        })
      : FirebaseFirestore.instance
          .collection(FirebaseFieldNames.productsCollection)
          .where(ProductFieldNames.categories, arrayContains: category)
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
