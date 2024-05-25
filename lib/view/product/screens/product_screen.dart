import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/cart/model/cart_payload.dart';
import 'package:quickfix/state/cart/repository/cart_repository.dart';
import 'package:quickfix/state/product/models/product.dart';
import 'package:quickfix/state/providers/scaffold_messenger.dart';
import 'package:quickfix/state/user/repositories/update_user.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/order/screens/confirmation_screen.dart';
import 'package:quickfix/view/product/components/details.dart';
import 'package:quickfix/view/product/components/product_image.dart';
import 'package:quickfix/view/strings.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  CarouselController controller = CarouselController();

  void buy() {
    if (widget.product.stock == 0) {
      ref
          .read(scaffoldMessengerProvider)
          .showSnackBar(const SnackBar(content: Text('Product not in stock!')));
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ConfirmationScreen(cart: [
        CartItem(
            name: widget.product.name,
            price: widget.product.price,
            productId: widget.product.id,
            quantity: 1)
      ]),
    ));
  }

  void addToCart() async {
    if (widget.product.stock == 0) {
      ref
          .read(scaffoldMessengerProvider)
          .showSnackBar(const SnackBar(content: Text('Product not in stock!')));
      return;
    }
    final cartPayload = CartPayload(
        name: widget.product.name,
        price: widget.product.price,
        productId: widget.product.id);
    final done =
        await ref.read(cartRepositoryProvider.notifier).addToCart(cartPayload);
    if (done) {
      ref
          .read(scaffoldMessengerProvider)
          .showSnackBar(const SnackBar(content: Text('Added to cart')));
    } else {
      ref.read(scaffoldMessengerProvider).showSnackBar(
          const SnackBar(content: Text('Failed to add product to cart')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartLoading = ref.watch(updateUserRepositoryProvider);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 50,
          leading: CircleAvatar(
            backgroundColor: Colors.black54,
            radius: 10,
            child: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(
                  Icons.navigate_before,
                  size: 35,
                  color: Colors.white,
                )),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ProductImage(images: widget.product.images),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(widget.product.description),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$rupee ${widget.product.price}',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                '$rupee ${widget.product.mrp}',
                                style: const TextStyle(
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.product.stock == 0
                                ? "Not In stock"
                                : "${widget.product.stock} in Stock",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MainButton(
                      onPressed: buy,
                      backgroundColor: QFTheme.mainGreen,
                      child: const Text(
                        'BUY NOW',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MainButton(
                      onPressed: addToCart,
                      backgroundColor: Colors.black,
                      child: cartLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'ADD TO CART',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Details(
                      details: widget.product.detail,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
