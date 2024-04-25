import 'package:flutter/material.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class CategoryScrollView extends StatefulWidget {
  const CategoryScrollView({super.key});

  @override
  State<CategoryScrollView> createState() => _CategoryScrollViewState();
}

class _CategoryScrollViewState extends State<CategoryScrollView> {
  String selectedCategory = "All";

  final categories = [
    "All",
    "Phones",
    "Earphones",
    "Watches",
    "Accessories",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.horizontal,
        children: categories
            .map((e) => InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = e;
                  });
                },
                child: CategoryItem(
                    category: e, selectedCategory: selectedCategory)))
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
          color: selected ? QFTheme.mainGreen : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black)),
      child: Center(
          child: Text(
        category,
        style: TextStyle(
          fontSize: 18,
          color: selected ? Colors.white : Colors.black,
          fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
        ),
      )),
    );
  }
}
