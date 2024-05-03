import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/cart/model/cart_payload.dart';
import 'package:quickfix/state/cart/providers/cart.dart';
import 'package:quickfix/state/cart/repository/cart_repository.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Scaffold(
      body: cart.when(
        data: (cart) {
          if (cart.isEmpty) {
            return Text('Cart is empty');
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(cart[index].name),
                      Text(cart[index].subtotal.toString()),
                    ],
                  ),
                  Text(cart[index].quantity.toString()),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            ref.read(cartRepositoryProvider.notifier).addToCart(
                                CartPayload(
                                    name: cart[index].name,
                                    price: cart[index].price,
                                    productId: cart[index].productId));
                          },
                          icon: Icon(Icons.add)),
                      IconButton(
                          onPressed: () {
                            ref
                                .read(cartRepositoryProvider.notifier)
                                .decrement(cart[index].productId);
                          },
                          icon: Icon(Icons.remove)),
                      IconButton(
                          onPressed: () {
                            ref
                                .read(cartRepositoryProvider.notifier)
                                .deleteItem(cart[index].productId);
                          },
                          icon: Icon(Icons.delete)),
                    ],
                  ),
                ],
              );
            },
            itemCount: cart.length,
          );
        },
        error: (e, st) => Text(e.toString()),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
