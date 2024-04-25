import 'package:flutter/material.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class MainButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  const MainButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: child,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(QFTheme.mainGreen),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder()),
        ),
      ),
    );
  }
}
