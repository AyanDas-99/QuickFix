import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CartItemShimmer extends StatelessWidget {
  const CartItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.blueGrey.shade100,
                highlightColor: Colors.white,
                child: Container(
                  color: Colors.grey,
                  width: 150,
                  height: 100,
                ),
              ),
              const SizedBox(width: 20),
              Shimmer.fromColors(
                baseColor: Colors.blueGrey.shade100,
                highlightColor: Colors.white,
                child: Container(
                  color: Colors.green,
                  height: 100,
                  width: 200,
                ),
              ),
            ],
          ),
          Shimmer.fromColors(
            baseColor: Colors.blueGrey.shade100,
            highlightColor: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonBar(
                  children: [
                    IconButton(
                        style: ButtonStyle(
                          shape: const MaterialStatePropertyAll(
                              RoundedRectangleBorder()),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blueGrey.shade50),
                        ),
                        onPressed: null,
                        icon: const Icon(Icons.remove)),
                    IconButton(
                        style: ButtonStyle(
                          shape: const MaterialStatePropertyAll(
                              RoundedRectangleBorder()),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blueGrey.shade50),
                        ),
                        onPressed: null,
                        icon: const Icon(Icons.add)),
                  ],
                ),
                Container(
                  width: 100,
                  height: 30,
                  color: Colors.grey,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
