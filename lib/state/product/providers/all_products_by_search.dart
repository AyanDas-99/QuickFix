import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/product/models/product.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_products_by_search.g.dart';

@riverpod
FutureOr<Iterable<Product>> allProductsBySearch(
    AllProductsBySearchRef ref, String query) async {
  final productsSnapshot = await FirebaseFirestore.instance
      .collection(FirebaseFieldNames.productsCollection)
      .get();

  final products = productsSnapshot.docs
      .map((e) => Product.fromMap(e.data(), e.id))
      .where((product) =>
          product.name.toUpperCase().contains(query.toUpperCase()) ||
          product.description
              .toString()
              .toUpperCase()
              .contains(query.toUpperCase()) ||
          product.categories.contains(query));
  return products;
}
