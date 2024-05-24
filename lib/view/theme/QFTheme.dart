import 'package:flutter/material.dart';

class QFTheme {
  static ThemeData theme = ThemeData(
      scaffoldBackgroundColor: Colors.blueGrey.shade50,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 25,
          color: mainBlack,
          fontWeight: FontWeight.w500,
        ),
        actionsIconTheme: IconThemeData(size: 25),
      ),
      snackBarTheme: const SnackBarThemeData(
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));

  static const Color mainGrey = Color(0xFFCCC9C9);
  // static Color mainGreen = const Color(0xFF21A41E);
  static const Color mainGreen = Color.fromARGB(255, 96, 114, 116);
  static const Color mainBlack = Colors.black;
  static const Color mainYellow = Color.fromARGB(255, 250, 238, 209);
}
