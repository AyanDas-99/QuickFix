import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/cart/model/cart_payload.dart';
import 'package:quickfix/state/cart/repository/cart_repository.dart';
import 'package:quickfix/state/product/providers/product_by_id.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/product/screens/product_screen.dart';
import 'package:quickfix/view/strings.dart';
import 'package:quickfix/view/tabs/cart/components/cart_item_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class CartItemCard extends ConsumerWidget {
  final CartItem cartItem;
  const CartItemCard({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(ProductByIdProvider(cartItem.productId));
    return product.when(
        data: (product) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 3,
            surfaceTintColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  (product == null)
                      ? const Text(
                          'The product does not exist. It might have been deleted by the owner. Any pending delivery of this will be cancelled and refunded.',
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ProductScreen(product: product),
                            ));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Image.network(
                                  (product.images.isEmpty)
                                      ? ''
                                      : product.images.first,
                                  width: 200,
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
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
                              const SizedBox(width: 20),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 10),
                                    Text('$rupee ${product.price}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    const SizedBox(height: 10),
                                    if (product.stock == 0)
                                      const Text(
                                        'Not in stock',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    if (product.stock != 0)
                                      Text(
                                        '${product.stock} in stock',
                                        style: TextStyle(
                                            color: Colors.green.shade900),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (product != null)
                        ButtonBar(
                          children: [
                            IconButton(
                                style: ButtonStyle(
                                  shape: const MaterialStatePropertyAll(
                                      RoundedRectangleBorder()),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.blueGrey.shade50),
                                ),
                                onPressed: () {
                                  ref
                                      .read(cartRepositoryProvider.notifier)
                                      .decrement(cartItem.productId);
                                },
                                icon: const Icon(Icons.remove)),
                            Text(cartItem.quantity.toString()),
                            IconButton(
                                style: ButtonStyle(
                                  shape: const MaterialStatePropertyAll(
                                      RoundedRectangleBorder()),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.blueGrey.shade50),
                                ),
                                onPressed: () {
                                  ref
                                      .read(cartRepositoryProvider.notifier)
                                      .addToCart(CartPayload(
                                          name: product.name,
                                          price: product.price,
                                          productId: product.id));
                                },
                                icon: const Icon(Icons.add)),
                          ],
                        ),
                      SizedBox(
                        width: 100,
                        child: MainButton(
                            onPressed: () {
                              ref
                                  .read(cartRepositoryProvider.notifier)
                                  .deleteItem(cartItem.productId);
                            },
                            backgroundColor: Colors.white,
                            child: const Text('Delete')),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        error: (e, st) => Text(e.toString()),
        loading: () => const CartItemShimmer());
  }
}
