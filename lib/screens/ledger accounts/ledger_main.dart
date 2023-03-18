import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/screens/app_drawer.dart';
import 'package:accouting_software/widgets/app_bar_popupmenu.dart';
import 'package:accouting_software/widgets/app_bar_popupmenubutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../icons/custom_icons_icons.dart';

class LedgerMain extends StatefulWidget {
  static const String routeName = "LedgerMain";

  @override
  State<LedgerMain> createState() => _LedgerMainState();
}

class _LedgerMainState extends State<LedgerMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _selectedDropDownItem;
  @override
  void initState() {
    // TODO: implement initState
    _selectedDropDownItem = "";
    super.initState();
  }

  var startDate = DateTime.now().subtract(Duration(days: 7));
  var endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (BuildContext ctx) {
            return IconButton(
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              icon: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(
                    CustomIcons.th_thumb,
                    size: 28,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
            );
          },
        ),
        title: Text(
          'L E D G E R\nA C C O U N T S',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [AppBarPopupmenuButton()],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Consumer<AccountsProvider>(
                  builder: (ctx, value, _) {
                    return DropdownButton(
                      hint: Text(
                        'Select an account',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      dropdownColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      items: value.accounts
                          .map((e) => DropdownMenuItem(
                              value: e.acc_name, child: Text(e.acc_name)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDropDownItem = value as String;
                        });
                      },
                    );
                  },
                ),
                Container(
                  child: Row(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
