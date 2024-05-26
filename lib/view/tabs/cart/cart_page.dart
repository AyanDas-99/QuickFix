import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/cart/providers/cart.dart';
import 'package:quickfix/state/product/providers/product_by_id.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/order/screens/confirmation_screen.dart';
import 'package:quickfix/view/tabs/cart/components/cart_item_card.dart';
import 'package:quickfix/view/tabs/cart/components/empty_sign.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  void cleanup(List<CartItem> cart, BuildContext context, WidgetRef ref) async {
    for (var item in cart) {
      final product =
          await ref.read(ProductByIdProvider(item.productId).future);
      if (product == null) {
        cart.remove(item);
      } else {
        if (item.quantity > product.stock) {
          item.quantity = product.stock;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Scaffold(
      appBar: customAppBar(true, context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cart.when(
          data: (cart) {
            print(cart);
            // Quantity cleanup
            cleanup(cart, context, ref);

            //

            if (cart.isEmpty) {
              return const Center(
                child: EmptySign(),
              );
            }
            return ListView(
              children: [
                MainButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConfirmationScreen(cart: cart),
                      ));
                    },
                    backgroundColor: QFTheme.mainGreen,
                    child: const Text(
                      'BUY',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                const SizedBox(height: 10),
                ...cart.map((e) => CartItemCard(cartItem: e))
              ],
            );
          },
          error: (e, st) => Text(e.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
