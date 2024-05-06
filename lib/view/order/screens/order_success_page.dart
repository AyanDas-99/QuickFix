import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/product/providers/product_by_id.dart';

class OrderSuccessPage extends ConsumerWidget {
  final List<CartItem> cart;
  const OrderSuccessPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(Icons.close)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.pinkAccent.shade100, width: 2),
                      borderRadius: BorderRadius.circular(50)),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.greenAccent.shade100, width: 1),
                        borderRadius: BorderRadius.circular(150)),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.lightBlue.shade100, width: 0.5),
                          borderRadius: BorderRadius.circular(150)),
                    ),
                  ),
                ).animate().then().scale(
                      delay: const Duration(seconds: 1),
                      duration: const Duration(milliseconds: 1300),
                      curve: Curves.fastOutSlowIn,
                      end: const Offset(350, 350),
                    ),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 50,
                          )
                              .animate()
                              .scale(
                                  begin: Offset(0, 0),
                                  end: Offset(1, 1),
                                  delay: Duration(seconds: 1),
                                  duration: Duration(milliseconds: 1000),
                                  curve: Curves.bounceOut)
                              .slideY(begin: -0.8, end: 0),
                          SizedBox(width: 10),
                          Text(
                            'Thank you for your order',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Column(
                        children: cart.map((e) {
                          final product =
                              ref.watch(ProductByIdProvider(e.productId));
                          return product.when(
                              data: (product) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Image.network(
                                          (product!.images.isNotEmpty)
                                              ? product.images.first
                                              : '',
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                                child: Icon(Icons.image));
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          product.name,
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: Text('x ${e.quantity}'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              error: (e, st) => Container(),
                              loading: () => const CircularProgressIndicator());
                        }).toList(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
