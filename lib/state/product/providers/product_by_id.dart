import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/product/models/product.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_by_id.g.dart';

@riverpod
Future<Product?> productById(ProductByIdRef ref, String id) async {
  final productSnap = await FirebaseFirestore.instance
      .collection(FirebaseFieldNames.productsCollection)
      .doc(id)
      .get();
  if (!productSnap.exists) {
    return null;
  }
  final product = Product.fromMap(
    productSnap.data()!,
    productSnap.id,
  );

  return product;
}
