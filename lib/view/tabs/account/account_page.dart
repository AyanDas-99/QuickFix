import 'package:flutter/material.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';
import 'package:quickfix/view/tabs/account/login_security_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(false, context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
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
          ],
        ),
      ),
    );
  }
}
