import 'package:flutter/material.dart';
import 'package:quickfix/state/product/models/description.dart';

class Details extends StatelessWidget {
  final List<Detail> details;
  const Details({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: List.generate(details.length, (index) {
        String? title = details[index].title;
        String? desc = details[index].description;
        return Container(
          padding: const EdgeInsets.all(8),
          color: (index % 2 == 0) ? Colors.grey.shade300 : Colors.grey.shade200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.2,
                child: Text(
                  title ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                  width: size.width * 0.7,
                  child: Text(desc ?? '', softWrap: true))
            ],
          ),
        );
      }),
    );
  }
}
