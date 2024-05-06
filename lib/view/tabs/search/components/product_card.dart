import 'package:flutter/material.dart';
import 'package:quickfix/state/product/models/product.dart';
import 'package:quickfix/view/extensions/shorten.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))
        ],
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: [
          Flexible(
            flex: 4,
            child: Image.network(
              (product.images.isEmpty) ? '' : product.images.first,
              width: 200,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.blueGrey,
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 20,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.image, size: 40),
                );
              },
            ),
          ),
          const SizedBox(width: 30),
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(product.description.shorten(30)),
                const SizedBox(height: 20),
                Text(
                  product.price.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green.shade700),
                ),
                Text(
                  product.mrp.toString(),
                  style:
                      const TextStyle(decoration: TextDecoration.lineThrough),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
