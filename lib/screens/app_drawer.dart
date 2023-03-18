import 'package:accouting_software/screens/accounts/accounts_main.dart';
import 'package:accouting_software/screens/home_screen.dart';
import 'package:accouting_software/screens/items/items_main.dart';
import 'package:accouting_software/screens/ledger%20accounts/ledger_main.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width / 1.7,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 2,
      child: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top +
                Scaffold.of(context).appBarMaxHeight!.toInt(),
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
            leading: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('D A S H B O A R D',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AccountsMain.routeName),
            leading: Icon(
              Icons.people,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('A C C O U N T S',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(LedgerMain.routeName),
            leading: Icon(
              Icons.book,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('L E D G E R\nA C C O U N T S',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          ListTile(
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(ItemsMain.routeName),
            leading: Icon(
              Icons.add_box_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('I T E M S',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          ListTile(
            leading: Icon(
              Icons.sell,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title:
                Text('S A L E', style: Theme.of(context).textTheme.bodyMedium),
          ),
          ListTile(
            leading: Icon(
              Icons.shop_2,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('P U R C H A S E',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          ListTile(
            leading: Icon(
              Icons.edit_note,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('V O U C H E R',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          ListTile(
            leading: Icon(
              Icons.description,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('T R I A L\nB A L A N C E',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
