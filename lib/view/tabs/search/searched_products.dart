import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/product/providers/all_products_by_search.dart';
import 'package:quickfix/view/product/screens/product_screen.dart';
import 'package:quickfix/view/tabs/search/components/product_card.dart';

class SearchedProducts extends ConsumerWidget {
  final String query;
  const SearchedProducts({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    controller.text = query;
    final products = ref.watch(allProductsBySearchProvider(query));
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          onSubmitted: (value) {
            if (controller.text.isEmpty) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SearchedProducts(
                        query: controller.text,
                      )),
            );
          },
        ),
      ),
      body: products.when(data: (products) {
        return LayoutBuilder(builder: (context, constraints) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => InkWell(
              child: ProductCard(product: products.elementAt(index)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProductScreen(product: products.elementAt(index)),
                ));
              },
            ),
          );
        });
      }, error: (e, st) {
        return Text(e.toString());
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
