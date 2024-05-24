import 'package:flutter/cupertino.dart';
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
          CupertinoIcons.cube_box,
          size: 40,
          color: QFTheme.mainGreen,
        ),
        SizedBox(height: 20),
        Text(
          'You have no orders.',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        )
      ],
    );
  }
}
