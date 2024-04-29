import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/product/components/details.dart';
import 'package:quickfix/view/product/components/product_image.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  var products = [
    'https://picsum.photos/300',
    'https://picsum.photos/400',
    'https://picsum.photos/200',
  ];

  CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
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
              ProductImage(images: [
                'https://picsum.photos/1200',
                'https://picsum.photos/1000',
                'https://picsum.photos/1500',
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Iphone 15 Pro Max(8 GB 128 GB) - Blue Titanium",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    Text("In Stock"),
                    const SizedBox(height: 20),
                    Text(
                      '\u{20B9} 70,000/',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '\u{20B9} 1,40,000/',
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
                            onPressed: () {
                              // Add to cart
                            },
                            child: Text(
                              'Add to cart',
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: QFTheme.mainGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Details(),
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
