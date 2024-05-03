import 'package:flutter/material.dart';
import 'package:quickfix/view/tabs/search/searched_products.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return SearchBar(
      controller: controller,
      hintText: "Search",
      leading: const Icon(Icons.search),
      onSubmitted: (value) {
        if (value.isEmpty) {
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SearchedProducts(query: controller.text),
        ));
      },
    );
  }
}
