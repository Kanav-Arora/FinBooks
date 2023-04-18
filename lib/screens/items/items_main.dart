import 'package:accouting_software/classes/item.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:accouting_software/screens/items/add_items.dart';
import 'package:accouting_software/screens/items/items_detail.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../icons/custom_icons_icons.dart';
import '../app_drawer.dart';

class ItemsMain extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const String routeName = "ItemsMain";

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
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
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
          'I T E M S',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddItems.routeName);
            },
            child: Icon(
              Icons.add,
              color: th.colorScheme.secondary,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: th.primaryColor,
        onRefresh: () {
          return Provider.of<ItemProvider>(context, listen: false).fetch();
        },
        child: Container(
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
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          Utilities().toastMessage(snapshot.error.toString());
                        } else if (snapshot.hasData) {
                          final data = snapshot.data as List<Item>;
                          return Expanded(
                            child: DataTable(
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
                                      'Quantity',
                                      style: th.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Price',
                                      style: th.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                data.length,
                                (index) {
                                  Item obj = data.elementAt(index);
                                  return DataRow(
                                    onSelectChanged: (value) {
                                      if (value == true) {
                                        Navigator.of(context).pushNamed(
                                            ItemsDetail.routeName,
                                            arguments: obj);
                                      }
                                    },
                                    cells: <DataCell>[
                                      DataCell(
                                        Text(obj.id),
                                      ),
                                      DataCell(
                                        Text(obj.name),
                                      ),
                                      DataCell(
                                        Text(obj.quantity),
                                      ),
                                      DataCell(
                                        Text(obj.price),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      }
                      return const CircularProgressIndicator();
                    }),
                    future:
                        Provider.of<ItemProvider>(context, listen: false).items,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
