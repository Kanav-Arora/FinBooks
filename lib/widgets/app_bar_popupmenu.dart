import 'package:accouting_software/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBarPopupmenu {
  BuildContext ctx;
  AppBarPopupmenu(this.ctx);
  List<PopupMenuItem<dynamic>> create() {
    return [
      PopupMenuItem(
        child: ListTile(
          leading: Icon(
            Icons.account_box,
            color: Theme.of(ctx).iconTheme.color,
          ),
          title: Text(
            "Account",
            style: TextStyle(color: Theme.of(ctx).colorScheme.secondary),
          ),
          onTap: () {},
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: Icon(
            Icons.logout,
            color: Theme.of(ctx).iconTheme.color,
          ),
          title: Text("Sign out",
              style: TextStyle(color: Theme.of(ctx).colorScheme.secondary)),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(ctx).pop();
            Navigator.of(ctx).pushReplacementNamed(LoginScreen.routeName);
          },
        ),
      ),
    ];
  }
}
