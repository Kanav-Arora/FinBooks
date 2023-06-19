import 'package:accouting_software/providers/expense_provider.dart';
import 'package:accouting_software/screens/operating%20expense/all_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/expense.dart';
import '../../providers/settings_provider.dart';
import '../../utils/utitlities.dart';

class ListExpense extends StatelessWidget {
  static const String routeName = "ListExpense";
  const ListExpense({super.key});

  Future<Map<String, List<Expense>>> fut(BuildContext context) async {
    Map<String, List<Expense>> data = {};
    data = await Provider.of<ExpenseProvider>(context, listen: false).catexp;
    return data;
  }

  Widget cardTile(String curr, Expense e, ThemeData th) {
    return Card(
      color: th.primaryColor,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${curr.substring(0, 1)} ${e.amount}"),
                Text(e.date)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(e.message)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    String cat = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: th.colorScheme.secondary,
          ),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => AllExpense()),
              (route) => false),
        ),
        elevation: 0,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: th.primaryColor,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                Utilities().toastMessage(snapshot.error.toString());
              } else if (snapshot.hasData) {
                final data = snapshot.data as Map<String, List<Expense>>;
                final ls = data.containsKey(cat) ? data[cat] : [];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return cardTile(
                          settingsProv.currency, ls.elementAt(index), th);
                    },
                    itemCount: ls!.length,
                  ),
                );
              }
            }
            return const Center(
              child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
            );
          },
          future: fut(context),
        ),
      ),
    );
  }
}
