import 'package:flutter/material.dart';

class CancelledBadge extends StatelessWidget {
  const CancelledBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10)),
      child: const Text(
        'Cancelled',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
