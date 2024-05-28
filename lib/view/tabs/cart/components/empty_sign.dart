import 'package:flutter/material.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class EmptySign extends StatelessWidget {
  const EmptySign({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_bag,
          size: 40,
          color: QFTheme.mainGreen,
        ),
        SizedBox(height: 20),
        Text(
          'Shopping bag is empty :(',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        )
      ],
    );
  }
}
