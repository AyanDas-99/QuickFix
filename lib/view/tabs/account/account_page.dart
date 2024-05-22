import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/auth/%20repositories/auth_repository.dart';
import 'package:quickfix/view/components/boolean_dialog.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';
import 'package:quickfix/view/tabs/account/components/profile_edit.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar(false, context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Account Settings",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Update Profile'),
              tileColor: Colors.white30,
              trailing: const Icon(Icons.navigate_next),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProfileEdit(),
                ));
              },
            ),
            const SizedBox(height: 10),
            Consumer(builder: (context, ref, child) {
              return ListTile(
                title: const Text('Log out'),
                tileColor: Colors.white30,
                trailing: const Icon(Icons.logout),
                onTap: () async {
                  bool? logout = await showBooleanDialog(
                      context: context,
                      title: 'Are you sure you want to log out?',
                      trueText: 'Log out',
                      falseText: 'Cancel');
                  if (logout == true) {
                    ref.read(authRepositoryNotifierProvider.notifier).signOut();
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
