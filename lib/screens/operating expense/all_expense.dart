import 'package:accouting_software/classes/expense.dart';
import 'package:accouting_software/providers/expense_provider.dart';
import 'package:accouting_software/screens/operating%20expense/list_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../icons/custom_icons_icons.dart';
import '../../providers/settings_provider.dart';
import '../../utils/utitlities.dart';
import '../home/app_drawer.dart';

class AllExpense extends StatefulWidget {
  static const String routeName = "AllExpense";

  @override
  State<AllExpense> createState() => _AllExpenseState();
}

class _AllExpenseState extends State<AllExpense> {
  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    List<String> exp = [
      "Accounting and legal fees",
      "Bank charges",
      "Office supplies",
      "Rent",
      "Repairs",
      "Salaries and wages",
      "Sales and marketing fees",
      "Utilities expenses",
      "Other",
    ];
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        drawer: AppDrawer(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext ctx) {
              return IconButton(
                onPressed: () => scaffoldKey.currentState!.openDrawer(),
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
            'A L L\nE X P E N S E S',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          width: size.width,
          height: size.height,
          color: th.primaryColor,
          child: FutureBuilder(
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  Utilities().toastMessage(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final data = snapshot.data as Map<String, List<Expense>>;
                  if (data.isEmpty) {
                    return Center(
                        child: Text(
                      'No operating expenses🧐',
                      style: th.textTheme.labelMedium,
                    ));
                  }
                  List<Theme> ls = [];
                  for (var cat in exp) {
                    if (data.containsKey(cat)) {
                      var values =
                          Provider.of<ExpenseProvider>(context, listen: false)
                              .expenseDataByList(data[cat] as List<Expense>);
                      String curr = settingsProv.currency.substring(0, 1);
                      ls.add(Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text(
                            cat,
                            style: th.textTheme.titleLarge,
                          ),
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: SizedBox(),
                                ),
                                MaterialButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(ListExpense.routeName,
                                          arguments: cat),
                                  child: Text(
                                    'Show All',
                                    style: th.textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const Text('This Month'),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text("$curr ${values.elementAt(0)}"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text('Last Month'),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text("$curr ${values.elementAt(1)}"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text('This Year'),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text("$curr ${values.elementAt(2)}"),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ));
                    }
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: ls,
                    ),
                  );
                }
              }
              return const Center(
                child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white))),
              );
            },
            future: Provider.of<ExpenseProvider>(context, listen: false).catexp,
          ),
        ));
  }
}
