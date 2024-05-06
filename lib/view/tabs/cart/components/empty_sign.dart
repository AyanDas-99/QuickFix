import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmptySign extends StatelessWidget {
  const EmptySign({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.cartShopping,
          size: 40,
        ),
        Text(
          'Your cart is empty',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        )
      ],
    );
  }
}
