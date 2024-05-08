import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/product/providers/product_by_id.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';

class OrderSuccessPage extends ConsumerWidget {
  final List<CartItem> cart;
  final PaymentSuccessResponse? paymentSuccessResponse;
  const OrderSuccessPage(
      {super.key, required this.cart, required this.paymentSuccessResponse});

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
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  )
                      .animate()
                      .scale(
                          begin: const Offset(0.1, 0.1),
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeIn)
                      .slideX(
                          begin: 30,
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.fastOutSlowIn),
                  const SizedBox(width: 10),
                  const Text(
                    'Thank you for your order',
                    style: TextStyle(fontSize: 20),
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
                          loading: () => Shimmer.fromColors(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
                                ),
                              ),
                              baseColor: Colors.blueGrey.shade50,
                              highlightColor: Colors.white));
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Container(
                      //   height: 1,
                      //   width: 1,
                      //   decoration: BoxDecoration(
                      //       border: Border.all(
                      //           color: Colors.greenAccent.shade400, width: 0.2),
                      //       borderRadius: BorderRadius.circular(50)),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //             color: Colors.greenAccent.shade200,
                      //             width: 0.1),
                      //         borderRadius: BorderRadius.circular(150)),
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //           border: Border.all(
                      //               color: Colors.greenAccent.shade100,
                      //               width: 0.05),
                      //           borderRadius: BorderRadius.circular(150)),
                      //     ),
                      //   ),
                      // )
                      //     .animate()
                      //     .then()
                      //     .scale(
                      //       delay: const Duration(seconds: 1),
                      //       duration: const Duration(milliseconds: 800),
                      //       curve: Curves.fastOutSlowIn,
                      //       end: const Offset(1000, 1000),
                      //     )
                      //     .then()
                      //     .scale(
                      //       duration: const Duration(milliseconds: 1000),
                      //       curve: Curves.fastOutSlowIn,
                      //       end: const Offset(-1, -1),
                      //     ),