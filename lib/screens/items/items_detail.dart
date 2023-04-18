import 'package:accouting_software/classes/bill.dart';
import 'package:accouting_software/classes/item.dart';
import 'package:accouting_software/providers/bill_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/utitlities.dart';

class ItemsDetail extends StatefulWidget {
  static const String routeName = "ItemsDetail";

  @override
  State<ItemsDetail> createState() => _ItemsDetailState();
}

class _ItemsDetailState extends State<ItemsDetail> {
  final _formkey = GlobalKey<FormState>();
  late List<String> _gstSlabsList;
  var gstValue;
  var _editable = false;

  @override
  void initState() {
    // TODO: implement initState
    _gstSlabsList = <String>["5%", "12%", "18%", "28%"];
    var gstValue;
    _editable = false;
    super.initState();
  }

  void initialize(Item a) {
    if (gstValue == null) {
      setState(() {
        gstValue = a.gstSlab;
      });
    }
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: th.colorScheme.secondary,
                  ),
                  Switch(
                    trackColor: trackColor,
                    activeColor: const Color.fromARGB(185, 23, 23, 23),
                    inactiveThumbColor: const Color.fromARGB(185, 23, 23, 23),
                    inactiveTrackColor: Colors.white,
                    value: _editable,
                    onChanged: (value) {
                      setState(() {
                        _editable = value;
                      });
                    },
                  ),
                  const Expanded(child: Text('')),
                  TextButton(
                      onPressed: null,
                      child: Text(
                        'Done',
                        style: th.textTheme.bodyMedium!.copyWith(
                            color: _editable == true
                                ? th.colorScheme.secondary
                                : Colors.grey),
                      ))
                ],
              ),
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
                            enabled: _editable,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: "Id",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 130, 130, 130)),
                              fillColor: const Color.fromARGB(255, 23, 23, 23),
                              filled: true,
                              hoverColor:
                                  Theme.of(context).colorScheme.secondary,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 181, 21, 221),
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
                            enabled: _editable,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: "Name",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 130, 130, 130)),
                              fillColor: const Color.fromARGB(255, 23, 23, 23),
                              filled: true,
                              hoverColor:
                                  Theme.of(context).colorScheme.secondary,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 181, 21, 221),
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
                    Row(
                      children: [
                        SizedBox(
                          width: (size.width - 40) / 3,
                          child: DropdownButton<String>(
                              iconSize: 0.0,
                              alignment: AlignmentDirectional.center,
                              hint: Text(
                                'GST Slab',
                                style: th.textTheme.bodyMedium!.copyWith(
                                    color: const Color.fromARGB(
                                        255, 130, 130, 130)),
                                textAlign: TextAlign.center,
                              ),
                              value: gstValue,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.grey,
                              ),
                              dropdownColor:
                                  const Color.fromARGB(255, 23, 23, 23),
                              onChanged: _editable == true
                                  ? (String? value) {
                                      setState(() {
                                        gstValue = value ?? "";
                                      });
                                      // a = Item(
                                      //   id: a.id,
                                      //   name: a.name,
                                      //   gstSlab: value.toString(),
                                      //   quantity: a.quantity,
                                      //   price: a.price,
                                      // );
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
                              }).toList()),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: (size.width - 40) / 3,
                          child: TextFormField(
                            initialValue: obj.price,
                            enabled: _editable,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              prefixText: "₹ ",
                              hintText: "Price",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 130, 130, 130)),
                              fillColor: const Color.fromARGB(255, 23, 23, 23),
                              filled: true,
                              hoverColor:
                                  Theme.of(context).colorScheme.secondary,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 181, 21, 221),
                                ),
                              ),
                            ),
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
                                  color: Color.fromARGB(255, 130, 130, 130)),
                              fillColor: const Color.fromARGB(255, 23, 23, 23),
                              filled: true,
                              hoverColor:
                                  Theme.of(context).colorScheme.secondary,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 181, 21, 221),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              FutureBuilder(
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      Utilities().toastMessage(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      List<String> data = snapshot.data as List<String>;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text('Last Price:'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(data.elementAt(0)),
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
                              Text(data.elementAt(2)),
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
                              Text(data.elementAt(1)),
                            ],
                          ),
                        ],
                      );
                    }
                  }
                  return const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)));
                },
                future: Provider.of<BillProvider>(context, listen: false)
                    .priceValues(obj.name),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                  child: FutureBuilder(
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      Utilities().toastMessage(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      List<BillItemDetail> data =
                          snapshot.data as List<BillItemDetail>;
                      data.sort(
                          (a, b) => (a.billDate.compareTo(b.billDate) * -1));
                      List<BillItemDetail> temp = data;
                      temp.sort((a, b) => a.billDate.compareTo(b.billDate));
                      return Column(
                        children: [
                          data.isNotEmpty
                              ? SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  title: ChartTitle(text: 'Price Change'),
                                  series: <LineSeries<BillItemDetail, String>>[
                                    LineSeries<BillItemDetail, String>(
                                        dataSource: temp,
                                        xValueMapper: (BillItemDetail b, _) =>
                                            b.billDate,
                                        yValueMapper: (BillItemDetail b, _) =>
                                            double.parse(b.price),
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                                isVisible: true))
                                  ],
                                )
                              : const SizedBox(),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (ctx, index) {
                                return BillItemDetailCard(
                                    th, data.elementAt(index));
                              },
                              itemCount: data.length,
                            ),
                          ),
                        ],
                      );
                    }
                  }
                  return const Center(
                      child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white))));
                },
                future: Provider.of<BillProvider>(context, listen: false)
                    .billByItemName(obj.name),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
