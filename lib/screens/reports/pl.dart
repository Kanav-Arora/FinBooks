import 'package:accouting_software/classes/pl_stat.dart';
import 'package:accouting_software/services/pl_statement_backend.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../icons/custom_icons_icons.dart';
import '../../providers/settings_provider.dart';
import '../../utils/utitlities.dart';
import '../home/app_drawer.dart';

class PLStatement extends StatefulWidget {
  static const String routeName = "PLStatement";

  @override
  State<PLStatement> createState() => _PLStatementState();
}

class _PLStatementState extends State<PLStatement> {
  ValueNotifier<PLStat> statementData = ValueNotifier(PLStat());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool firstLoad = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    final String curr = settingsProv.currency.substring(0, 1);
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
          'P L\nS T A T E M E N T',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
        // actions: [
        //   MaterialButton(
        //     onPressed: null,
        //     child: Icon(
        //       Icons.download,
        //       color: th.colorScheme.secondary,
        //     ),
        //   )
        // ],
      ),
      body: Container(
          color: th.primaryColor,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  Utilities().toastMessage(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final data = snapshot.data as Map<String, PLStat>;
                  final yrs = data.keys;
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: OutlinedButton(
                                  onPressed: () {
                                    firstLoad = false;
                                    statementData.value =
                                        data[yrs.elementAt(index)] as PLStat;
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    side: BorderSide(
                                        width: 0.5,
                                        color: th.colorScheme.secondary),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      yrs.elementAt(index),
                                      style: th.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: yrs.length,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: ValueListenableBuilder(
                              builder: (context, value, child) {
                                if (firstLoad == true) {
                                  return const Center(
                                      child: Text(
                                          'Please select a financial year to fetch report'));
                                }
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Revenue',
                                          style: th.textTheme.labelLarge!
                                              .copyWith(color: Colors.blue),
                                        ),
                                        const Expanded(
                                          child: SizedBox(),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 2,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Sales',
                                                style: th.textTheme.labelMedium,
                                              ),
                                              Text(
                                                '${value.sales}',
                                                style: th.textTheme.labelMedium,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Cost of Goods Sold',
                                                style: th.textTheme.labelMedium,
                                              ),
                                              Text(
                                                '${value.cogs * -1}',
                                                style: th.textTheme.labelMedium,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Expanded(child: SizedBox()),
                                              Text(
                                                '${value.sales - value.cogs}',
                                                style: th.textTheme.labelMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Expense',
                                          style: th.textTheme.labelLarge!
                                              .copyWith(color: Colors.blue),
                                        ),
                                        const Expanded(
                                          child: SizedBox(),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 2,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          ...value.expenseCat.entries.map((e) {
                                            return Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        e.key,
                                                        style: th.textTheme
                                                            .labelMedium,
                                                      ),
                                                      Text('${e.value}',
                                                          style: th.textTheme
                                                              .labelMedium),
                                                    ]),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            );
                                          }),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Expanded(child: SizedBox()),
                                              Text(
                                                '${value.expenseTotal}',
                                                style: th.textTheme.labelMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    const Divider(
                                      thickness: 2,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Net Income',
                                              style: th.textTheme.labelLarge,
                                            ),
                                            Text(
                                              '${value.sales - value.cogs - value.expenseTotal}',
                                              style: th.textTheme.labelMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    const Divider(
                                      thickness: 2,
                                    ),
                                  ],
                                );
                              },
                              valueListenable: statementData,
                            ),
                          ),
                        ),
                      )),
                    ],
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
            future: PLStatementBackend().getData(context),
          )),
    );
  }
}
