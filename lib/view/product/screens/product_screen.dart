import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/product/models/product.dart';
import 'package:quickfix/state/user/repositories/update_user.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/product/components/details.dart';
import 'package:quickfix/view/product/components/product_image.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  CarouselController controller = CarouselController();

  void addToCart() async {
    final done = await ref
        .read(updateUserRepositoryProvider.notifier)
        .addToCart(widget.product.id);
    if (done) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Added to cart')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product to cart')));
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
                icon: Icon(
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
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Text(widget.product.description),
                    const SizedBox(height: 20),
                    Text(widget.product.stock == 0
                        ? "Not In stock"
                        : "${widget.product.stock} in Stock"),
                    const SizedBox(height: 20),
                    Text(
                      '\u{20B9} ${widget.product.price}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '\u{20B9} ${widget.product.mrp}',
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Flexible(
                          child: MainButton(
                            onPressed: () {
                              // buy
                            },
                            child: Text(
                              'Buy Now',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: QFTheme.mainGreen,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: MainButton(
                            onPressed: addToCart,
                            child: cartLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Add to cart',
                                    style: TextStyle(color: Colors.black),
                                  ),
                            backgroundColor: QFTheme.mainGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Details(
                      details: widget.product.detail,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
