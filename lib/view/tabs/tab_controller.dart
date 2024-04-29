import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickfix/view/tabs/account/account_page.dart';
import 'package:quickfix/view/tabs/cart/cart_page.dart';
import 'package:quickfix/view/tabs/orders/orders_page.dart';
import 'package:quickfix/view/tabs/home/home_page.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class TabControllerScreen extends StatefulWidget {
  const TabControllerScreen({super.key});

  @override
  State<TabControllerScreen> createState() => _TabControllerScreenState();
}

class _TabControllerScreenState extends State<TabControllerScreen> {
  int currentPage = 0;

  final pages = const [
    HomePage(),
    CartPage(),
    OrdersPage(),
    AccountPage(),
    // Random(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 300),
          color: QFTheme.mainGreen,
          index: currentPage,
          items: const [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            Icon(
              CupertinoIcons.cube_box,
              color: Colors.white,
            ),
            Icon(
              CupertinoIcons.person,
              color: Colors.white,
            ),
          ],
          onTap: (int page) {
            setState(() {
              currentPage = page;
            });
          },
        ),
        body: pages[currentPage],
      ),
    );
  }
}
