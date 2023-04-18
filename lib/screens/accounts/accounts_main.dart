import 'package:accouting_software/classes/account.dart';
import 'package:accouting_software/classes/account_data_object.dart';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:accouting_software/screens/accounts/add_account.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../icons/custom_icons_icons.dart';
import '../app_drawer.dart';

class tabledata {
  Account a;
  AccountDataObject d;
  tabledata(this.a, this.d);
}

class AccountsMain extends StatefulWidget {
  static const String routeName = "AccountsMain";

  @override
  State<AccountsMain> createState() => _AccountsMainState();
}

class _AccountsMainState extends State<AccountsMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<tabledata>> fut(BuildContext ctx) async {
    List<Account> data1 =
        await Provider.of<AccountsProvider>(context, listen: false).accounts;
    List<tabledata> ls = [];
    for (Account i in data1) {
      final d = await Provider.of<TransactionProvider>(ctx, listen: false)
          .dataByAccName(i.acc_name);
      ls.add(tabledata(i, d));
    }
    return ls;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
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
          'A C C O U N T S',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
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
      body: Container(
        color: th.primaryColor,
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
                FutureBuilder(
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        Utilities().toastMessage('Some Error Occured');
                      } else if (snapshot.hasData) {
                        final data = snapshot.data as List<tabledata>;
                        return Expanded(
                            child: SingleChildScrollView(
                                child: DataTable(
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
                                  'Debit',
                                  style: th.textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Credit',
                                  style: th.textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                            data.length,
                            (index) {
                              tabledata o = data.elementAt(index);
                              Account obj = o.a;
                              AccountDataObject d = o.d;
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Text(obj.id),
                                  ),
                                  DataCell(
                                    Text(obj.acc_name),
                                  ),
                                  DataCell(
                                    Text(
                                      d.debit.toStringAsFixed(2),
                                      style: TextStyle(
                                          color: d.debit > d.credit
                                              ? Colors.redAccent
                                              : th.colorScheme.secondary),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      d.credit.toStringAsFixed(2),
                                      style: TextStyle(
                                          color: d.credit > d.debit
                                              ? Colors.greenAccent
                                              : th.colorScheme.secondary),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )));
                      }
                    }
                    return const CircularProgressIndicator();
                  },
                  future: fut(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
