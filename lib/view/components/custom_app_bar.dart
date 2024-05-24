import 'package:flutter/material.dart';
import 'package:quickfix/view/tabs/home/components/home_search_bar.dart';

PreferredSizeWidget customAppBar(
  bool home, {
  bool canGoBack = false,
  required BuildContext context,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(home ? 120 : 48),
    child: AppBar(
      leading: !canGoBack
          ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: Image.asset("assets/logo/quickfix_logo.png"),
              ),
            )
          : IconButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              icon: const Icon(Icons.navigate_before)),
      title: const Text(
        "QuickFix",
      ),
      bottom: home
          ? const PreferredSize(
              preferredSize: Size.fromHeight(10),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: HomeSearchBar(),
              ))
          : null,
    ),
  );
}
