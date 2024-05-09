import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/auth/%20repositories/auth_repository.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';
import 'package:quickfix/view/order/screens/order_success_page.dart';
import 'package:quickfix/view/tabs/account/login_security_page.dart';
import 'package:quickfix/view/test_screen.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: customAppBar(false, context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              user!.displayName!,
            ),
            const SizedBox(height: 20),
            const Text(
              "Account Settings",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Login & Security'),
              tileColor: Colors.white30,
              trailing: const Icon(Icons.navigate_next),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginSecurityPage(),
                ));
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Address'),
              tileColor: Colors.white30,
              trailing: const Icon(Icons.navigate_next),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            Consumer(builder: (context, ref, child) {
              return ListTile(
                title: const Text('Log out'),
                tileColor: Colors.white30,
                trailing: const Icon(Icons.logout),
                onTap: () {
                  ref.read(authRepositoryNotifierProvider.notifier).signOut();
                },
              );
            }),
            ListTile(
              title: const Text('Test'),
              tileColor: Colors.white30,
              trailing: const Icon(Icons.navigate_next),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TestScreen(),
                ));
              },
            ),
            ListTile(
              title: const Text('Payment test'),
              tileColor: Colors.white30,
              trailing: const Icon(Icons.navigate_next),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderSuccessPage(
                    cart: [
                      CartItem(
                          name: 'Iphone pro max 15',
                          price: 120000,
                          productId: 'pfUWPgX8OwXbWtDvMDCe',
                          quantity: 2)
                    ],
                    paymentSuccessResponse: null,
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
