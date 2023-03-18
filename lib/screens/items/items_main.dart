import 'package:accouting_software/classes/item.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../icons/custom_icons_icons.dart';
import '../../widgets/app_bar_popupmenubutton.dart';
import '../app_drawer.dart';

class ItemsMain extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const String routeName = "ItemsMain";

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
          'I T E M S',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: const [AppBarPopupmenuButton()],
      ),
      body: SingleChildScrollView(
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
                onPressed: () {},
                child: Icon(
                  Icons.add,
                  color: th.colorScheme.secondary,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(child: Consumer<ItemProvider>(
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
                      value.items.length,
                      (index) {
                        Item obj = value.items.elementAt(index);
                        return DataRow(
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
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
