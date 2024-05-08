import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/order/models/order.dart';
import 'package:quickfix/state/order/providers/orders_provider.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      body: orders.when(
          data: (ordersIterable) {
            final List<Order> orders = ordersIterable.toList();
            orders.sort((a, b) => a.timestamp.isAfter(b.timestamp) ? 0 : 1);
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders.elementAt(index);
                return ListTile(
                  title: SelectableText(order.id),
                  subtitle: Text(order.orderId ?? 'No order id'),
                  trailing: Text(order.orderStatus.name),
                );
              },
            );
          },
          error: (e, st) => Text(e.toString()),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
