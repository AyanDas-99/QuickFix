import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quickfix/state/product/models/product.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 1),
      ),
      color: Colors.white,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              (product.images.isEmpty) ? '' : product.images.first,
              // height: 100,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.blueGrey,
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 10,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.image),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    product.name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    product.name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
