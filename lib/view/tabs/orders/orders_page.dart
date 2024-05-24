import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/order/models/order.dart';
import 'package:quickfix/state/order/providers/orders_provider.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';
import 'package:quickfix/view/order/screens/order_details.dart';
import 'package:quickfix/view/tabs/orders/components/empty_sign.dart';
import 'package:quickfix/view/tabs/orders/components/order_card.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      appBar: customAppBar(true, context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: orders.when(
            data: (ordersIterable) {
              if (ordersIterable.isEmpty) {
                return const Center(child: EmptySign());
              }
              final List<Order> orders = ordersIterable.toList();
              orders.sort((a, b) => a.timestamp.isAfter(b.timestamp) ? 0 : 1);
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders.elementAt(index);
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailsScreen(order: order),
                        ));
                      },
                      child: OrderCard(order: order));
                },
              );
            },
            error: (e, st) => Text(e.toString()),
            loading: () => const CircularProgressIndicator()),
      ),
    );
  }
}
