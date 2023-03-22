import 'package:accouting_software/classes/account.dart';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../icons/custom_icons_icons.dart';
import '../../widgets/app_bar_popupmenubutton.dart';
import '../app_drawer.dart';

enum Toggles { cash, credit }

class AddSale extends StatefulWidget {
  static const String routeName = "AddSale";

  @override
  State<AddSale> createState() => _AddSaleState();
}

class _AddSaleState extends State<AddSale> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<bool> _selectedOption = <bool>[true, false];
  var _selectedToggle = Toggles.credit;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _billDateController = TextEditingController();
  late var _selectedAccount;

  @override
  void initState() {
    _selectedToggle = Toggles.credit;
    _selectedAccount = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final List<Widget> toggleButtonOptions = [
      Text(
        'Credit',
        style: th.textTheme.bodyMedium,
      ),
      Text(
        'Cash',
        style: th.textTheme.bodyMedium,
      ),
    ];
    return Scaffold(
      key: _scaffoldKey,
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
          'S A L E',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [const AppBarPopupmenuButton()],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: th.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  SizedBox(
                    width: (size.width - 20) / 2,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "Id",
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 130, 130, 130)),
                        fillColor: const Color.fromARGB(255, 23, 23, 23),
                        filled: true,
                        hoverColor: Theme.of(context).colorScheme.secondary,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 181, 21, 221),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ToggleButtons(
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < _selectedOption.length; i++) {
                          _selectedOption[i] = i == index;
                        }
                        if (index == 0) {
                          _selectedToggle = Toggles.credit;
                        } else {
                          _selectedToggle = Toggles.cash;
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderColor: Colors.grey,
                    selectedBorderColor: th.colorScheme.secondary,
                    selectedColor: Colors.white,
                    fillColor: const Color.fromARGB(255, 23, 23, 23),
                    color: const Color.fromARGB(255, 23, 23, 23),
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected: _selectedOption,
                    children: toggleButtonOptions,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        Utilities().toastMessage(snapshot.error.toString());
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        return DropdownButton<String>(
                            hint: Text(
                              'Select an account',
                              style: th.textTheme.bodyMedium!.copyWith(
                                  color:
                                      const Color.fromARGB(255, 130, 130, 130)),
                              textAlign: TextAlign.center,
                            ),
                            value: _selectedAccount,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            dropdownColor:
                                const Color.fromARGB(255, 23, 23, 23),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedAccount = value ?? "";
                              });
                            },
                            items: data!
                                .map<DropdownMenuItem<String>>((Account value) {
                              return DropdownMenuItem<String>(
                                value: value.acc_name,
                                child: Text(
                                  value.acc_name,
                                  style: th.textTheme.bodyMedium,
                                ),
                              );
                            }).toList());
                      }
                    }
                    return Text(
                      'Fetching accounts data',
                      style: th.textTheme.bodyMedium,
                    );
                  },
                  future: Provider.of<AccountsProvider>(context, listen: false)
                      .accounts,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bill date',
                          style: th.textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: (size.width - 50) / 2,
                          child: TextField(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101));
                              if (picked != null && picked != selectedDate) {
                                setState(() {
                                  selectedDate = picked;
                                  _billDateController.text =
                                      DateFormat.yMd().format(selectedDate);
                                });
                              }
                            },
                            controller: _billDateController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: "dd/mm/yy",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 130, 130, 130)),
                              fillColor: const Color.fromARGB(255, 23, 23, 23),
                              filled: true,
                              hoverColor:
                                  Theme.of(context).colorScheme.secondary,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 181, 21, 221),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Due date',
                          style: th.textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: (size.width - 50) / 2,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: "dd/mm/yy",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 130, 130, 130)),
                              fillColor: const Color.fromARGB(255, 23, 23, 23),
                              filled: true,
                              hoverColor:
                                  Theme.of(context).colorScheme.secondary,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 181, 21, 221),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
