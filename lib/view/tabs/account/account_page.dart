import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/auth/%20repositories/auth_repository.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';
import 'package:quickfix/view/payments/payment_screen.dart';
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
              title: Text('Login \& Security'),
              tileColor: Colors.white30,
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginSecurityPage(),
                ));
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text('Address'),
              tileColor: Colors.white30,
              trailing: Icon(Icons.navigate_next),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            Consumer(builder: (context, ref, child) {
              return ListTile(
                title: Text('Log out'),
                tileColor: Colors.white30,
                trailing: Icon(Icons.logout),
                onTap: () {
                  ref.read(authRepositoryNotifierProvider.notifier).signOut();
                },
              );
            }),
            ListTile(
              title: Text('Test'),
              tileColor: Colors.white30,
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TestScreen(),
                ));
              },
            ),
            ListTile(
              title: Text('Payment test'),
              tileColor: Colors.white30,
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentScreen(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
