import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/product/providers/product_by_id.dart';
import 'package:quickfix/state/user/providers/user_by_id.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userByIdProvider(ref.watch(userProvider)!.uid));
    return Scaffold(
      body: user.when(
        data: (user) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final product = ref.watch(productByIdProvider(user.cart[index]));
              return product.when(
                  data: (product) {
                    return ListTile(
                      title: Text(product?.name ?? 'Null'),
                    );
                  },
                  error: (e, st) => ListTile(
                        title: Text('Error: ${e.toString()}'),
                      ),
                  loading: () => const CircularProgressIndicator());
            },
            itemCount: user.cart.length,
          );
        },
        error: (e, st) => Text(e.toString()),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
