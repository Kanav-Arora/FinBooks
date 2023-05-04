import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../home/home_screen.dart';

class OperatingExpense extends StatefulWidget {
  static const String routeName = "OperatingExpense";

  @override
  State<OperatingExpense> createState() => _OperatingExpenseState();
}

class _OperatingExpenseState extends State<OperatingExpense> {
  final ValueNotifier<String> _notifierExpCat = ValueNotifier("");
  final ValueNotifier<bool> _notifierTEExpCat = ValueNotifier(false);
  final TextEditingController _dateController = TextEditingController();
  final ValueNotifier<String> _notifierDate = ValueNotifier("");
  final TextEditingController _controllerMessage = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<String> exp = [
    "Rent",
    "Salaries and wages",
    "Accounting and legal fees",
    "Bank charges",
    "Sales and marketing fees",
    "Office supplies",
    "Repairs",
    "Utilities expenses",
    "Other"
  ];

  bool onSave() {
    bool ret = false;
    if (!_formkey.currentState!.validate()) ret = true;
    if (_notifierExpCat.value == "") {
      _notifierTEExpCat.value = true;
      ret = true;
    }

    if (ret) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
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
            'O P E R A T I N G\nE X P E N S E S',
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
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formkey,
                child: Row(
                  children: [
                    SizedBox(
                      width: (size.width - 50) / 1.5,
                      child: ValueListenableBuilder(
                        valueListenable: _notifierExpCat,
                        builder: (ctx, value, child) {
                          return ValueListenableBuilder(
                            valueListenable: _notifierTEExpCat,
                            builder: (ctx, value, child) {
                              return DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Select a Category',
                                    style: th.textTheme.bodyMedium!.copyWith(
                                        color: const Color.fromARGB(
                                            255, 130, 130, 130)),
                                    textAlign: TextAlign.center,
                                  ),
                                  value: _notifierExpCat.value == ""
                                      ? null
                                      : _notifierExpCat.value,
                                  elevation: 16,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 136, 78, 236)),
                                  underline: Container(
                                    height: 2,
                                    color: (_notifierTEExpCat.value == true &&
                                            _notifierExpCat.value == "")
                                        ? Colors.redAccent
                                        : Colors.grey,
                                  ),
                                  dropdownColor: settingsProv.isDark == true
                                      ? const Color.fromARGB(255, 23, 23, 23)
                                      : Colors.white,
                                  onChanged: (String? value) {
                                    _notifierExpCat.value = value.toString();
                                  },
                                  items: exp.map<DropdownMenuItem<String>>(
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
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: SizedBox(
                      height: 50,
                      child: ValueListenableBuilder(
                          valueListenable: _notifierDate,
                          builder: (ctx, value, child) {
                            return TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Select a date';
                                }
                                return null;
                              },
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime(2101));
                                if (picked != null) {
                                  _notifierDate.value =
                                      DateFormat.yMd().format(picked);
                                  _dateController.text = _notifierDate.value;
                                  _notifierDate.notifyListeners();
                                }
                              },
                              controller: _dateController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: "dd/mm/yy",
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
                            );
                          }),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                maxLines: 5,
                controller: _controllerMessage,
                decoration: InputDecoration(
                  hintText: "Expense Message",
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                child: OutlinedButton(
                  onPressed: () {
                    if (onSave()) return;
                  },
                  style: OutlinedButton.styleFrom(
                    side:
                        BorderSide(width: 1.0, color: th.colorScheme.secondary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.wallet,
                        color: th.colorScheme.secondary,
                      ),
                      Text(
                        'Create Expense',
                        style: th.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
