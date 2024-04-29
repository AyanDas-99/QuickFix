import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class ProductImage extends StatefulWidget {
  final List<String> images;
  const ProductImage({
    super.key,
    required this.images,
  });

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  int? currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  currentPage = index;
                });
              },
              aspectRatio: 1,
              viewportFraction: 1,
              enableInfiniteScroll: false,
            ),
            items: List.generate(widget.images.length, (index) {
              String image = widget.images[index];
              return SizedBox(
                height: constraints.maxWidth,
                width: constraints.maxWidth,
                child: Center(
                  child: Image.network(
                    image,
                    height: constraints.maxWidth,
                    fit: BoxFit.fitHeight,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.blueGrey,
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: constraints.maxWidth * 0.7,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.image),
                      );
                    },
                  )
                      .animate(target: (currentPage == index) ? 0 : 1)
                      .scale(end: const Offset(0.7, 0.7)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                widget.images.length,
                (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 5,
                      )
                          .animate(target: (currentPage == index) ? 0 : 1)
                          .scale(end: const Offset(0.5, 0.5))
                          .moveY(begin: -2),
                    )),
          )
        ],
      );
    });
  }
}
