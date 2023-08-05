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
                      final item = ls.elementAt(index) as Expense;
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.redAccent,
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Icon(Icons.delete, color: Colors.white),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: const [
                            //     ,
                            //     SizedBox(
                            //       width: 8.0,
                            //     ),
                            //     Text('Move to favorites',
                            //         style: TextStyle(color: Colors.white)),
                            //   ],
                            // ),
                          ),
                        ),
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: th.primaryColor,
                                actionsAlignment:
                                    MainAxisAlignment.spaceBetween,
                                actionsPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                title: const Text("Delete"),
                                content: const Text(
                                    "Are you sure you want to delete this expense"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(
                                        "No",
                                        style: th.textTheme.labelMedium,
                                      )),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(
                                        "Yes",
                                        style: th.textTheme.labelMedium,
                                      )),
                                ],
                              );
                            },
                          );
                        },
                        key: Key(item.id),
                        onDismissed: (direction) async {
                          try {
                            await Provider.of<ExpenseProvider>(context,
                                    listen: false)
                                .removeExpense(item.id, item.category);
                          } catch (error) {
                            Utilities().toastMessage(error.toString());
                          }
                          Utilities().successMessage('Expense deleted');
                        },
                        child: cardTile(settingsProv.currency, item, th),
                      );
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
