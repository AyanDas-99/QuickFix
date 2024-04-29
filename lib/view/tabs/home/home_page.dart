import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/view/product/screens/product_screen.dart';
import 'package:quickfix/view/tabs/home/components/category_scroll_view.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';
import 'package:quickfix/view/tabs/home/components/product_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar(true, context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CategoryScrollView(),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductScreen(),
                    ));
                  },
                  child: const ProductCard(
                      name: "Ham burger", description: "Good Hamburger"),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
              )
            ],
          ),
        ),
      ),
    );
  }
}
