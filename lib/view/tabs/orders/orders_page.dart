import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/order/providers/orders_provider.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      body: orders.when(
          data: (orders) {
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders.elementAt(index);
                return ListTile(
                  title: Text(order.id),
                );
              },
            );
          },
          error: (e, st) => Text(e.toString()),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
