import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAccount extends StatelessWidget {
  const UserAccount({super.key});
  static const String routeName = "UserAccount";
  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    print(FirebaseAuth.instance.currentUser);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'A C C O U N T',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Save'),
          ),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: th.primaryColor,
      ),
    );
  }
}
