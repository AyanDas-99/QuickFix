import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/product/providers/all_products.dart';
import 'package:quickfix/state/product/providers/all_products_by_category.dart';
import 'package:quickfix/view/product/screens/product_screen.dart';
import 'package:quickfix/view/tabs/home/components/category_scroll_view.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';
import 'package:quickfix/view/tabs/home/components/product_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(allProductsByCategoryProvider);
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        ref.invalidate(allProductsByCategoryProvider);
      },
      child: Scaffold(
        appBar: customAppBar(true, context: context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CategoryScrollView(),
                allProducts.when(
                    data: (products) {
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) =>
                            InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductScreen(),
                            ));
                          },
                          child: ProductCard(
                            product: products.elementAt(index),
                          ),
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                      );
                    },
                    error: (e, st) => const Text("Error"),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
