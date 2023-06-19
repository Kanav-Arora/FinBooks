import 'package:accouting_software/screens/accounts/accounts_main.dart';
import 'package:accouting_software/screens/home/home_screen.dart';
import 'package:accouting_software/screens/items/items_main.dart';
import 'package:accouting_software/screens/ledger%20accounts/ledger_main.dart';
import 'package:accouting_software/screens/operating%20expense/all_expense.dart';
import 'package:accouting_software/screens/operating%20expense/operating_expense.dart';
import 'package:accouting_software/screens/purchase/add_purchase.dart';
import 'package:accouting_software/screens/reports/pl.dart';
import 'package:accouting_software/screens/sale/add_sale.dart';
import 'package:accouting_software/screens/settings.dart';
import 'package:accouting_software/screens/voucher/voucher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app login/login_screen.dart';

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
            height: MediaQuery.of(context).padding.top,
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
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AddSale.routeName);
            },
            leading: Icon(
              Icons.sell,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title:
                Text('S A L E', style: Theme.of(context).textTheme.bodyMedium),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AddPurchase.routeName);
            },
            leading: Icon(
              Icons.shop_2,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('P U R C H A S E',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Voucher.routeName);
            },
            leading: Icon(
              Icons.edit_note,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('V O U C H E R',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text("O P E R A T I N G\nE X P E N S E S"),
              leading: Icon(
                Icons.description,
                color: Theme.of(context).colorScheme.secondary,
              ),
              childrenPadding: const EdgeInsets.only(left: 20),
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AllExpense.routeName);
                  },
                  leading: Icon(
                    Icons.stacked_bar_chart,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text('All Expenses',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(OperatingExpense.routeName);
                  },
                  leading: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text('Add Expenses',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text("R E P O R T S"),
              leading: Icon(
                Icons.document_scanner,
                color: Theme.of(context).colorScheme.secondary,
              ),
              childrenPadding: const EdgeInsets.only(left: 20),
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(PLStatement.routeName);
                  },
                  leading: Icon(
                    Icons.monetization_on,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text('PL Statement',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(Settings.routeName);
            },
            title: Text('S E T T I N G S',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text("S I G N  O U T",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName, (Route route) => false);
            },
          ),
        ],
      ),
    );
  }
}
