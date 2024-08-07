import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/product/providers/category.dart';
import 'package:quickfix/state/product/strings/categories.dart';

class CategoryScrollView extends StatefulWidget {
  const CategoryScrollView({super.key});

  @override
  State<CategoryScrollView> createState() => _CategoryScrollViewState();
}

class _CategoryScrollViewState extends State<CategoryScrollView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.horizontal,
        children: categories
            .map((e) => Consumer(builder: (context, ref, child) {
                  return GestureDetector(
                      onTap: () {
                        ref.read(categoryProvider.notifier).state = e;
                      },
                      child: CategoryItem(
                          category: e,
                          selectedCategory: ref.watch(categoryProvider)));
                }))
            .toList(),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String category;
  final String selectedCategory;
  const CategoryItem(
      {super.key, required this.category, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    bool selected = category == selectedCategory;
    return Container(
      constraints: const BoxConstraints(minWidth: 80),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: selected ? Colors.green : Colors.grey.shade400,
                offset: selected ? const Offset(0, 6) : const Offset(0, 3))
          ]),
      child: Center(
          child: Text(
        category,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
        ),
      )),
    );
  }
}
