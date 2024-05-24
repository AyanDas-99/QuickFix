import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/order/models/order.dart';
import 'package:quickfix/state/order/models/order_status.dart';
import 'package:quickfix/state/product/providers/product_by_id.dart';
import 'package:quickfix/view/tabs/orders/components/cancelled_badge.dart';
import 'package:quickfix/view/tabs/orders/components/delivered_badge.dart';
import 'package:shimmer/shimmer.dart';

class OrderCard extends ConsumerWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 20),
          elevation: 3,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  const Text(
                    'Order ID: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SelectableText(order.id),
                  Expanded(
                    child: Container(),
                  ),
                  const Icon(Icons.navigate_next)
                ],
              ),
              const SizedBox(height: 10),
              ...order.items.map((e) {
                final product = ref.watch(ProductByIdProvider(e.productId));
                return product.when(
                  data: (product) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: (product == null)
                              ? const Text(
                                  'The product does not exist. It might have been deleted by the owner. Any pending delivery of this will be cancelled and refunded.')
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Image.network(
                                        (product.images.isEmpty)
                                            ? ''
                                            : product.images.first,
                                        width: 200,
                                        fit: BoxFit.contain,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            color: Colors.grey,
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(Icons.image, size: 40),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Flexible(
                                        flex: 4,
                                        child: Text(
                                          product.name,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ))
                                  ],
                                ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                  error: (error, stackTrace) => Container(),
                  loading: () => Shimmer.fromColors(
                    baseColor: Colors.blueGrey.shade100,
                    highlightColor: Colors.white,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  ),
                );
              }),
            ]),
          ),
        ),
        if (order.orderStatus == OrderStatus.cancelled)
          Positioned(
            bottom: 50,
            left: 0,
            child: Transform.rotate(
              angle: 45,
              child: const CancelledBadge(),
            ),
          ),
        if (order.orderStatus == OrderStatus.delivered)
          Positioned(
            bottom: 50,
            left: 0,
            child: Transform.rotate(
              angle: 45,
              child: const DeliveredBadge(),
            ),
          ),
      ],
    );
  }
}
