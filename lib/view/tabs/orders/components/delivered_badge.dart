import 'package:flutter/material.dart';

class DeliveredBadge extends StatelessWidget {
  const DeliveredBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(10)),
      child: const Text(
        'Delivered',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
