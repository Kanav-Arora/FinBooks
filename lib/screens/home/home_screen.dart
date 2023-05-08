import 'package:accouting_software/classes/transactions_stat.dart';
import 'package:accouting_software/icons/custom_icons_icons.dart';
import 'package:accouting_software/providers/expense_provider.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:accouting_software/providers/settings_provider.dart';
import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:accouting_software/screens/home/app_drawer.dart';
import 'package:accouting_software/screens/home/user_account.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../classes/item.dart';

import '../../utils/utitlities.dart';

class Data {
  List<double> operatingexpValues = [];
  String curr = "";
  List<Item> outOfStock = [];
  bool isDark = false;
  TransStat t = TransStat();
}

class HomeScreen extends StatefulWidget {
  static const String routeName = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Data> fut(DateTime start, DateTime end) async {
    var d = Data();
    d.operatingexpValues =
        await Provider.of<ExpenseProvider>(context, listen: false)
            .expenseData();
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    await settingsProv.fetch(context);
    d.curr = settingsProv.currency.substring(0, 1);
    d.isDark = settingsProv.isDark;
    d.outOfStock =
        await Provider.of<ItemProvider>(context, listen: false).outOfStock();
    d.t = await Provider.of<TransactionProvider>(context, listen: false)
        .stats(context, start, end);
    return d;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final th = Theme.of(context);
    var today = DateTime.now();
    var minus = 0;
    if (today.month <= 3) {
      minus = 1;
    }
    var fiscalStart = DateTime(DateTime.now().year - minus, 4, 1);
    var fiscalEnd = DateTime(DateTime.now().year + (minus == 1 ? 0 : 1), 3, 31);
    return Scaffold(
      key: _scaffoldKey,
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
        actions: [
          MaterialButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(UserAccount.routeName),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 30,
              child: const CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                'https://www.wikihow.com/images/6/61/Draw-a-Cartoon-Man-Step-15.jpg',
              )),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        width: size.width,
        height: size.height,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    Utilities().toastMessage(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    final data = snapshot.data as Data;
                    final operatigexp = data.operatingexpValues;
                    final outofStock = data.outOfStock;
                    final TransStat t = data.t;
                    return Column(children: [
                      SizedBox(
                        width: size.width - 30,
                        child: Text(
                          'Financials',
                          style: th.textTheme.labelLarge!
                              .copyWith(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: data.isDark == false
                            ? BoxDecoration(
                                border: Border.all(
                                    color: th.colorScheme.secondary,
                                    width: 0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)))
                            : const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 22, 21, 27)),
                        padding: const EdgeInsets.all(25),
                        width: size.width - 30,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Revenue',
                                style: th.textTheme.labelSmall,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "${data.curr} ${t.revenue}",
                                style: th.textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w900, fontSize: 27),
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: data.isDark == false
                            ? BoxDecoration(
                                border: Border.all(
                                    color: th.colorScheme.secondary,
                                    width: 0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)))
                            : const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 22, 21, 27)),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profit/Loss',
                                style: th.textTheme.labelSmall,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${data.curr} ${t.profit}",
                                    style: th.textTheme.labelMedium,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  t.profitMonth > t.profitAverage
                                      ? const Icon(
                                          Icons.moving,
                                          color: Colors.greenAccent,
                                        )
                                      : const Icon(
                                          Icons.trending_down,
                                          color: Colors.redAccent,
                                        ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              t.profitMonth > t.profitAverage
                                  ? Row(
                                      children: [
                                        Text(
                                          "${(t.profitMonth - t.profitAverage).toStringAsFixed(2)} ( ${((t.profitMonth - t.profitAverage) / t.profitAverage).toStringAsFixed(2)}% )",
                                          style: th.textTheme.labelSmall!
                                              .copyWith(
                                                  color: Colors.greenAccent,
                                                  fontSize: 12),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text('More',
                                            style: th.textTheme.labelSmall!
                                                .copyWith(fontSize: 12)),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          "${(t.profitAverage - t.profitMonth).toStringAsFixed(2)} ( ${((t.profitMonth - t.profitAverage) / t.profitAverage).toStringAsFixed(2)}% )",
                                          style: th.textTheme.labelSmall!
                                              .copyWith(
                                                  color: Colors.redAccent,
                                                  fontSize: 12),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text('Less',
                                            style: th.textTheme.labelSmall!
                                                .copyWith(fontSize: 12)),
                                      ],
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                            ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: data.isDark == false
                            ? BoxDecoration(
                                border: Border.all(
                                    color: th.colorScheme.secondary,
                                    width: 0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)))
                            : const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 22, 21, 27)),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'COGS',
                                style: th.textTheme.labelSmall,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${data.curr} ${t.cogs}",
                                    style: th.textTheme.labelMedium,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  t.cogsMonth > t.cogsAverage
                                      ? const Icon(
                                          Icons.moving,
                                          color: Colors.greenAccent,
                                        )
                                      : const Icon(
                                          Icons.trending_down,
                                          color: Colors.redAccent,
                                        ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              t.cogsMonth > t.cogsAverage
                                  ? Text(
                                      "${(t.cogsMonth - t.cogsAverage).toStringAsFixed(2)} ( ${(t.cogsMonth - t.cogsAverage) / t.cogsAverage}% )",
                                      style: th.textTheme.labelSmall!.copyWith(
                                          color: Colors.greenAccent,
                                          fontSize: 12),
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          "${(t.cogsAverage - t.cogsMonth).toStringAsFixed(2)} ( ${(t.cogsMonth - t.cogsAverage) / t.cogsAverage}% )",
                                          style: th.textTheme.labelSmall!
                                              .copyWith(
                                                  color: Colors.redAccent,
                                                  fontSize: 12),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text('Less',
                                            style: th.textTheme.labelSmall!
                                                .copyWith(fontSize: 12)),
                                      ],
                                    ),
                              const SizedBox(
                                height: 10,
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      t.graphCashFlow.isNotEmpty
                          ? SfCartesianChart(
                              margin: const EdgeInsets.all(15),
                              enableAxisAnimation: true,
                              backgroundColor: th.primaryColor,
                              plotAreaBorderColor: Colors.white,
                              primaryXAxis: CategoryAxis(
                                  name: 'primaryXAxis',
                                  labelStyle: TextStyle(
                                      color: th.colorScheme.secondary)),
                              primaryYAxis: NumericAxis(
                                  labelStyle: TextStyle(
                                      color: th.colorScheme.secondary)),
                              series: <CartesianSeries>[
                                AreaSeries<List<String>, String>(
                                    borderColor: th.colorScheme.secondary,
                                    borderWidth: 1.5,
                                    color: const Color.fromARGB(
                                        150, 118, 200, 147),
                                    // trendlines: <Trendline>[
                                    //   Trendline(
                                    //       type: TrendlineType.linear,
                                    //       color: Colors.greenAccent)
                                    // ],
                                    dataSource: t.graphCashFlow,
                                    xValueMapper: (List<String> b, _) => b[0],
                                    yValueMapper: (List<String> b, _) =>
                                        double.parse(b[1]),
                                    dataLabelSettings: DataLabelSettings(
                                        textStyle: TextStyle(
                                            color: th.colorScheme.secondary),
                                        isVisible: true)),
                                LineSeries<List<String>, String>(
                                    color: Colors.redAccent,
                                    dataSource: t.graphCashFlow,
                                    dashArray: <double>[5, 5],
                                    xValueMapper: (List<String> data, _) =>
                                        data[0],
                                    yValueMapper: (List<String> data, _) =>
                                        double.parse(t.avg)),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: size.width - 30,
                        child: Text(
                          'Operating Expenses',
                          style: th.textTheme.labelSmall,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                              Text("${data.curr} ${operatigexp.elementAt(0)}"),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Last Month'),
                              const SizedBox(
                                height: 7,
                              ),
                              Text("${data.curr} ${operatigexp.elementAt(1)}"),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('This Year'),
                              const SizedBox(
                                height: 7,
                              ),
                              Text("${data.curr} ${operatigexp.elementAt(2)}"),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: size.width - 30,
                        child: Text(
                          'Inventory',
                          style: th.textTheme.labelLarge!
                              .copyWith(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: size.width - 30,
                        child: Text(
                          'Out of Stock',
                          style: th.textTheme.labelSmall,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DataTable(
                        showCheckboxColumn: false,
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
                                'Price (${data.curr})',
                                style: th.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'GST',
                                style: th.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          outofStock.length,
                          (index) {
                            Item obj = outofStock.elementAt(index);
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(obj.id),
                                ),
                                DataCell(
                                  Text(obj.name),
                                ),
                                DataCell(
                                  Text(obj.price),
                                ),
                                DataCell(
                                  Text(obj.gstSlab),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const Divider(),
                    ]);
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
              future: fut(fiscalStart, fiscalEnd),
            ),
          ),
        ),
      ),
    );
  }
}
