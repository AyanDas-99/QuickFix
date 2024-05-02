// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quickfix/state/product/models/description.dart';
import 'package:quickfix/state/product/strings/product_field_names.dart';

class Product {
  final String name;
  final List<String> images;
  final List<Description> description;
  final List<String> categories;
  final int mrp;
  final int price;
  final int stock;
  final String id;

  Product({
    required this.name,
    required this.images,
    required this.description,
    required this.categories,
    required this.mrp,
    required this.price,
    required this.stock,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ProductFieldNames.name: name,
      ProductFieldNames.images: images,
      ProductFieldNames.description: description,
      ProductFieldNames.categories: categories,
      ProductFieldNames.mrp: mrp,
      ProductFieldNames.price: price,
      ProductFieldNames.stock: stock,
      ProductFieldNames.id: id,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      name: map[ProductFieldNames.name] as String,
      images: List<String>.from(map[ProductFieldNames.images]),
      description: (map[ProductFieldNames.description] as List)
          .map((map) => Description(
              title: map[ProductFieldNames.title],
              description: map[ProductFieldNames.description]))
          .toList(),
      categories: List<String>.from(map[ProductFieldNames.categories] ?? []),
      mrp: map[ProductFieldNames.mrp] as int,
      price: map[ProductFieldNames.price] as int,
      stock: map[ProductFieldNames.stock] as int,
      id: id,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source, String id) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>, id);
}
