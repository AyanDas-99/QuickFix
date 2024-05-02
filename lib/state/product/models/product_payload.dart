// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:quickfix/state/product/models/description.dart';
import 'package:quickfix/state/product/strings/product_field_names.dart';

class ProductPayload extends MapView<String, dynamic> {
  final String name;
  final List<String> images;
  final List<Description> description;
  final List<String> categories;
  final int mrp;
  final int price;
  final int stock;
  ProductPayload({
    required this.name,
    required this.images,
    required this.description,
    required this.categories,
    required this.mrp,
    required this.price,
    required this.stock,
  }) : super({
          ProductFieldNames.name: name,
          ProductFieldNames.images: images,
          ProductFieldNames.description:
              description.map((e) => e.toMap()).toList(),
          ProductFieldNames.categories: categories,
          ProductFieldNames.mrp: mrp,
          ProductFieldNames.price: price,
          ProductFieldNames.stock: stock,
        });

  ProductPayload copyWithImages(List<String> imageLinks) => ProductPayload(
        name: name,
        images: imageLinks,
        description: description,
        categories: categories,
        mrp: mrp,
        price: price,
        stock: stock,
      );
}
