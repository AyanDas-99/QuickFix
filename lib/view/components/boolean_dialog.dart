import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<bool?> showBooleanDialog(
    {required BuildContext context,
    required String title,
    Widget? content,
    required String trueText,
    required falseText}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: <Widget>[
          TextButton(
            child: Text(falseText),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text(trueText),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
