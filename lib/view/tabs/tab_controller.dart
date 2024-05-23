import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/user/providers/user_by_id.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:quickfix/view/tabs/account/account_page.dart';
import 'package:quickfix/view/tabs/account/components/profile_edit.dart';
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
        body: Consumer(builder: (context, ref, child) {
          final uid = ref.read(userProvider)!.uid;
          print(uid);
          final user = ref.watch(UserByIdProvider(uid));
          return Stack(
            children: [
              pages[currentPage],
              user.when(
                  data: (user) {
                    if (user.shippingAddress == null) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProfileEdit(),
                          ));
                        },
                        child: Container(
                          width: double.infinity,
                          color: Colors.red,
                          child: const Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Click to please add your shipping address.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ).animate(delay: 2.seconds).moveY(
                            begin: -150, end: 0, curve: Curves.fastOutSlowIn),
                      );
                    }
                    return Container();
                  },
                  error: (e, st) => Text('Error'),
                  loading: () => Text('Loading'))
            ],
          );
        }),
      ),
    );
  }
}
