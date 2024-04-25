import 'package:flutter/material.dart';
import 'package:quickfix/view/tabs/home/components/home_search_bar.dart';

PreferredSizeWidget customAppBar() {
  return PreferredSize(
    preferredSize: Size.fromHeight(110),
    child: AppBar(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Image.asset("assets/logo/quickfix_logo.jpeg"),
        ),
      ),
      title: Text(
        "QuickFix",
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
            ))
      ],
      flexibleSpace: Container(),
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HomeSearchBar(),
          )),
    ),
  );
}
