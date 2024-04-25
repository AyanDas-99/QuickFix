import 'package:flutter/material.dart';

class QFTheme {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: mainGrey,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 25,
        color: mainBlack,
        fontWeight: FontWeight.w500,
      ),
      actionsIconTheme: IconThemeData(size: 25),
    ),
  );

  static const Color mainGrey = Color(0xFFCCC9C9);
  static const Color mainGreen = Color(0xFF21A41E);
  static const Color mainBlack = Colors.black;
}
