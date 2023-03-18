import 'package:accouting_software/classes/account.dart';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/screens/accounts/add_account.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../icons/custom_icons_icons.dart';
import '../../widgets/app_bar_popupmenubutton.dart';
import '../app_drawer.dart';

enum Toggles { all, credit, debit }

class AccountsMain extends StatefulWidget {
  static const String routeName = "AccountsMain";

  @override
  State<AccountsMain> createState() => _AccountsMainState();
}

class _AccountsMainState extends State<AccountsMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<bool> _selectedOption = <bool>[true, false, false];
  var _selectedToggle = Toggles.all;

  @override
  void initState() {
    // TODO: implement initState
    _selectedToggle = Toggles.all;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final List<Widget> toggleButtonOptions = [
      Text(
        'All',
        style: th.textTheme.bodyMedium,
      ),
      Text(
        'Credit',
        style: th.textTheme.bodyMedium,
      ),
      Text(
        'Debit',
        style: th.textTheme.bodyMedium,
      ),
    ];
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
          'A C C O U N T S',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [const AppBarPopupmenuButton()],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            await Provider.of<AccountsProvider>(context, listen: false).fetch();
          } catch (error) {
            Utilities().toastMessage(error.toString());
          }
        },
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            color: th.primaryColor,
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _selectedOption.length; i++) {
                            _selectedOption[i] = i == index;
                          }
                          if (index == 0) {
                            _selectedToggle = Toggles.all;
                          } else if (index == 1) {
                            _selectedToggle = Toggles.credit;
                          } else {
                            _selectedToggle = Toggles.debit;
                          }
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderColor: th.colorScheme.secondary,
                      selectedBorderColor: Colors.purple[700],
                      selectedColor: Colors.white,
                      fillColor: Colors.purple[300],
                      color: Colors.purple[400],
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      isSelected: _selectedOption,
                      children: toggleButtonOptions,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AddAccount.routeName);
                      },
                      child: Icon(
                        Icons.add,
                        color: th.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(child: SingleChildScrollView(
                  child: Consumer<AccountsProvider>(
                    builder: (ctx, value, _) {
                      return DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Id',
                                style: th.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Name',
                                style: th.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Type',
                                style: th.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Amount',
                                style: th.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          value.accounts.length,
                          (index) {
                            Account obj = value.accounts.elementAt(index);
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(obj.id),
                                ),
                                DataCell(
                                  Text(obj.acc_name),
                                ),
                                DataCell(
                                  Text(obj.acc_type),
                                ),
                                const DataCell(
                                  Text('0'),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
