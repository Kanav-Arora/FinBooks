import 'package:accouting_software/classes/account.dart';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:accouting_software/screens/accounts/add_account.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../icons/custom_icons_icons.dart';
import '../../widgets/app_bar_popupmenubutton.dart';
import '../app_drawer.dart';

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
        actions: const [AppBarPopupmenuButton()],
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
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddAccount.routeName);
                  },
                  child: Icon(
                    Icons.add,
                    color: th.colorScheme.secondary,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                FutureBuilder(
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        Utilities().toastMessage('Some Error Occured');
                      } else if (snapshot.hasData) {
                        final data = snapshot.data as List<Account>;
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
                              Account obj = data.elementAt(index);
                              final d = Provider.of<TransactionProvider>(
                                      context,
                                      listen: false)
                                  .dataByAccName(obj.acc_name);
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
                  future: Provider.of<AccountsProvider>(context, listen: false)
                      .accounts,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
