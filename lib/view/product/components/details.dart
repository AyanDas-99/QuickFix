import 'package:flutter/material.dart';
import 'package:quickfix/state/product/models/description.dart';

class Details extends StatelessWidget {
  final List<Detail> details;
  const Details({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(details.length, (index) {
            String? title = details[index].title;
            String? desc = details[index].description;
            return Container(
              padding: const EdgeInsets.all(8),
              color: (index % 2 == 0) ? Colors.grey.shade300 : Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      title ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      desc ?? '',
                      softWrap: true,
                    ),
                  )
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
