import 'package:accouting_software/classes/expense.dart';
import 'package:accouting_software/providers/expense_provider.dart';
import 'package:accouting_software/screens/operating%20expense/list_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../utils/utitlities.dart';
import '../home/home_screen.dart';

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
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: th.colorScheme.secondary,
            ),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) => HomeScreen()),
                (route) => false),
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
                          title: Text(cat),
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
                                  child: const Text('Show All'),
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
