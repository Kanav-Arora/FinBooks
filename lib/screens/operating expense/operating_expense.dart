import 'package:accouting_software/classes/expense.dart';
import 'package:accouting_software/providers/expense_provider.dart';
import 'package:accouting_software/utils/utitlities.dart';
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
  final ValueNotifier<String> _notifierAmount = ValueNotifier("");
  final TextEditingController _controllerMessage = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  Expense e = Expense(category: "", date: "", amount: "");
  List<String> exp = [
    "Accounting and legal fees",
    "Bank charges",
    "Office supplies",
    "Rent",
    "Repairs",
    "Salaries and wages",
    "Sales and marketing fees",
    "Utilities expenses",
    "Other",
  ];

  bool onSave() {
    bool ret = false;
    if (!_formkey.currentState!.validate()) ret = true;
    if (_notifierExpCat.value == "") {
      _notifierTEExpCat.value = true;
      ret = true;
    }
    if (ret) return true;
    _formkey.currentState!.save();
    e = Expense(
        category: _notifierExpCat.value,
        date: _notifierDate.value,
        amount: _notifierAmount.value,
        message: _controllerMessage.text.toString());
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
            'A D D\nE X P E N S E',
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
              ValueListenableBuilder(
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
                                color:
                                    const Color.fromARGB(255, 130, 130, 130)),
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
                          items:
                              exp.map<DropdownMenuItem<String>>((String value) {
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
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formkey,
                child: Row(
                  children: [
                    SizedBox(
                      width: (size.width - 60) / 2,
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
                              onSaved: (newValue) {
                                _notifierDate.value = newValue.toString();
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
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    SizedBox(
                      width: (size.width - 60) / 2,
                      height: 50,
                      child: ValueListenableBuilder(
                          valueListenable: _notifierAmount,
                          builder: (ctx, value, child) {
                            return TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter an amount';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _notifierAmount.value = newValue.toString();
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                prefixText:
                                    settingsProv.currency.substring(0, 1),
                                hintText: "Amount",
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
                    ),
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
                  onPressed: () async {
                    if (onSave()) return;
                    try {
                      await Provider.of<ExpenseProvider>(context, listen: false)
                          .addExpense(e);
                      Navigator.of(context)
                          .pushReplacementNamed(OperatingExpense.routeName);
                    } catch (error) {
                      Utilities().toastMessage(error.toString());
                    }
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
