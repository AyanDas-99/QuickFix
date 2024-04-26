import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final Color backgroundColor;
  const MainButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(backgroundColor),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder()),
        ),
      ),
    );
  }
}
