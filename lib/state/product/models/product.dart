// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quickfix/state/product/models/description.dart';
import 'package:quickfix/state/product/strings/product_field_names.dart';

class Product {
  final String name;
  final List<String> images;
  final List<Description> description;
  final int mrp;
  final int price;
  final int stock;

  Product({
    required this.name,
    required this.images,
    required this.description,
    required this.mrp,
    required this.price,
    required this.stock,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ProductFieldNames.name: name,
      ProductFieldNames.images: images,
      ProductFieldNames.description: description,
      ProductFieldNames.mrp: mrp,
      ProductFieldNames.price: price,
      ProductFieldNames.stock: stock,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map[ProductFieldNames.name] as String,
      images:
          List<String>.from((map[ProductFieldNames.images] as List<String>)),
      description:
          (map[ProductFieldNames.description] as List<Map<String, String>>)
              .map((map) => Description(
                  title: map[ProductFieldNames.title],
                  description: map[ProductFieldNames.description]))
              .toList(),
      mrp: map[ProductFieldNames.mrp] as int,
      price: map[ProductFieldNames.price] as int,
      stock: map[ProductFieldNames.stock] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
