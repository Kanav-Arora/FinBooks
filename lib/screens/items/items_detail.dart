import 'package:accouting_software/classes/bill.dart';
import 'package:accouting_software/classes/item.dart';
import 'package:accouting_software/providers/bill_provider.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:accouting_software/providers/settings_provider.dart';
import 'package:accouting_software/screens/items/items_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../utils/utitlities.dart';

class FutData {
  List<String> priceValueData = [];
  List<BillItemDetail> graphData = [];
  List<BillItemDetail> listData = [];

  FutData(this.priceValueData, this.graphData, this.listData);
}

class ItemsDetail extends StatefulWidget {
  static const String routeName = "ItemsDetail";

  @override
  State<ItemsDetail> createState() => _ItemsDetailState();
}

class _ItemsDetailState extends State<ItemsDetail> {
  final ValueNotifier<String> _notifierGST = ValueNotifier("");
  final ValueNotifier<String> _notifierPrice = ValueNotifier("");
  final ValueNotifier<bool> _notifierEditable = ValueNotifier(false);

  final _formkey = GlobalKey<FormState>();
  late List<String> _gstSlabsList;
  var gstValue;

  @override
  void initState() {
    // TODO: implement initState
    _gstSlabsList = <String>["5%", "12%", "18%", "28%"];
    super.initState();
  }

  void initialize(Item a) {
    _notifierGST.value = a.gstSlab;
    _notifierPrice.value = a.price;
  }

  Future<FutData> fut(Item obj) async {
    List<String> priceValueData = [];
    List<BillItemDetail> graphData = [];
    List<BillItemDetail> listData = [];
    priceValueData = await Provider.of<BillProvider>(context, listen: false)
        .priceValues(obj.name);
    List<BillItemDetail> data =
        await Provider.of<BillProvider>(context, listen: false)
            .billByItemName(obj.name);
    data.sort((a, b) => ((a.billDate).compareTo(b.billDate)));
    listData = List.from(data.reversed);
    graphData = data;
    return FutData(priceValueData, graphData, listData);
  }

  Widget BillItemDetailCard(ThemeData th, BillItemDetail b) {
    return Card(
      color: th.primaryColor,
      margin: const EdgeInsets.all(10.0),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${b.billNo}: ${b.accName}",
                style: th.textTheme.bodyMedium,
              ),
              Text(
                b.billDate,
                style: th.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Quantity: ${b.qty}",
                style: th.textTheme.bodySmall,
              ),
              Text(
                "Price:  ₹ ${b.price}",
                style: th.textTheme.bodySmall,
              ),
            ],
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final obj = ModalRoute.of(context)!.settings.arguments as Item;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Color.fromARGB(255, 181, 21, 221);
        }
        return null;
      },
    );
    var appBar = AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.of(context).pushNamed(ItemsMain.routeName);
        },
      ),
      foregroundColor: th.colorScheme.secondary,
      elevation: 0,
    );
    double screenHeightMinusAppBarMinusStatusBar =
        MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top;

    initialize(obj);
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: size.width,
        height: size.height,
        color: th.primaryColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: _notifierEditable,
                    builder: ((ctx, _, child) {
                      return Row(children: [
                        Icon(
                          Icons.edit,
                          color: th.colorScheme.secondary,
                        ),
                        Switch(
                          trackColor: trackColor,
                          activeColor: const Color.fromARGB(185, 23, 23, 23),
                          inactiveThumbColor:
                              const Color.fromARGB(185, 23, 23, 23),
                          inactiveTrackColor: th.colorScheme.secondary,
                          value: _notifierEditable.value,
                          onChanged: (bool value) {
                            _notifierEditable.value = value;
                            _notifierGST.notifyListeners();
                            _notifierPrice.notifyListeners();
                          },
                        ),
                        const Expanded(child: Text('')),
                        TextButton(
                            onPressed: () async {
                              await Provider.of<ItemProvider>(context,
                                      listen: false)
                                  .updateItem(obj, _notifierGST.value,
                                      _notifierPrice.value);
                              _notifierEditable.value = false;
                              _notifierEditable.notifyListeners();
                            },
                            child: Text(
                              'Done',
                              style: th.textTheme.bodyMedium!.copyWith(
                                  color: _notifierEditable.value == true
                                      ? th.colorScheme.secondary
                                      : Colors.grey),
                            ))
                      ]);
                    })),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: (size.width - 40) / 3,
                            child: TextFormField(
                              initialValue: obj.id,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: "Id",
                                hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 130, 130, 130)),
                                fillColor: settingsProv.isDark == true
                                    ? const Color.fromARGB(255, 23, 23, 23)
                                    : Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 23, 23, 23),
                                    width: 4.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: obj.name,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 130, 130, 130)),
                                fillColor: settingsProv.isDark == true
                                    ? const Color.fromARGB(255, 23, 23, 23)
                                    : Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 23, 23, 23),
                                    width: 4.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ValueListenableBuilder(
                        builder: (ctx, _, child) {
                          return Row(
                            children: [
                              SizedBox(
                                width: (size.width - 40) / 3,
                                child: ValueListenableBuilder(
                                  builder: (ctx, _, child) {
                                    return DropdownButton<String>(
                                        iconSize: 0.0,
                                        alignment: AlignmentDirectional.center,
                                        hint: Text(
                                          'GST Slab',
                                          style: th.textTheme.bodyMedium!
                                              .copyWith(
                                                  color: const Color.fromARGB(
                                                      255, 130, 130, 130)),
                                          textAlign: TextAlign.center,
                                        ),
                                        value: _notifierGST.value,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                        dropdownColor: const Color.fromARGB(
                                            255, 23, 23, 23),
                                        onChanged: _notifierEditable.value
                                            ? (String? value) {
                                                _notifierGST.value =
                                                    value.toString();
                                                _notifierGST.notifyListeners();
                                              }
                                            : null,
                                        items: _gstSlabsList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: th.textTheme.bodyMedium,
                                            ),
                                          );
                                        }).toList());
                                  },
                                  valueListenable: _notifierGST,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: (size.width - 40) / 3,
                                child: ValueListenableBuilder(
                                  builder: (ctx, _, child) {
                                    return TextFormField(
                                      onChanged: ((value) {
                                        _notifierPrice.value = value;
                                      }),
                                      initialValue: _notifierPrice.value,
                                      enabled: _notifierEditable.value,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        prefixText: "₹ ",
                                        hintText: "Price",
                                        hintStyle: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 130, 130, 130)),
                                        fillColor: settingsProv.isDark == true
                                            ? const Color.fromARGB(
                                                255, 23, 23, 23)
                                            : Colors.white,
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 23, 23, 23),
                                            width: 4.0,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  valueListenable: _notifierPrice,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: obj.quantity,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    prefixText: "Qty ",
                                    hintText: "Quantity",
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 130, 130, 130)),
                                    fillColor: settingsProv.isDark == true
                                        ? const Color.fromARGB(255, 23, 23, 23)
                                        : Colors.white,
                                    filled: true,
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 23, 23, 23),
                                        width: 4.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        valueListenable: _notifierEditable,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                FutureBuilder(
                  builder: ((ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        Utilities().toastMessage(snapshot.error.toString());
                      } else if (snapshot.hasData) {
                        final data = snapshot.data as FutData;
                        List<String> priceValueData = data.priceValueData;
                        List<BillItemDetail> graphData = data.graphData;
                        List<BillItemDetail> listData = data.listData;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const Text('Last Price:'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(priceValueData.elementAt(0)),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    const Text('Maximum Price:'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(priceValueData.elementAt(2)),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    const Text('Minimum Price:'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(priceValueData.elementAt(1)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            listData.isNotEmpty
                                ? SfCartesianChart(
                                    backgroundColor: th.primaryColor,
                                    plotAreaBorderColor: Colors.white,
                                    primaryXAxis: CategoryAxis(
                                        name: 'primaryXAxis',
                                        labelStyle: TextStyle(
                                            color: th.colorScheme.secondary)),
                                    primaryYAxis: NumericAxis(
                                        labelStyle: TextStyle(
                                            color: th.colorScheme.secondary)),
                                    series: <
                                        LineSeries<BillItemDetail, String>>[
                                      LineSeries<BillItemDetail, String>(
                                          color: Colors.lightBlue,
                                          trendlines: <Trendline>[
                                            Trendline(
                                                type: TrendlineType.linear,
                                                color: Colors.greenAccent)
                                          ],
                                          dataSource: graphData,
                                          xValueMapper: (BillItemDetail b, _) =>
                                              b.billDate,
                                          yValueMapper: (BillItemDetail b, _) =>
                                              double.parse(b.price),
                                          dataLabelSettings: DataLabelSettings(
                                              textStyle: TextStyle(
                                                  color:
                                                      th.colorScheme.secondary),
                                              isVisible: true))
                                    ],
                                  )
                                : const SizedBox(),
                            ...listData
                                .map((e) => BillItemDetailCard(th, e))
                                .toList(),
                          ],
                        );
                      }
                    }
                    return const SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white)));
                  }),
                  future: fut(obj),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
