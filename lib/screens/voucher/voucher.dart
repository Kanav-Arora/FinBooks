import 'package:accouting_software/classes/account.dart';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:accouting_software/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../classes/transaction.dart';
import '../../providers/settings_provider.dart';
import '../../utils/utitlities.dart';

enum TypeToggles { pay, receive }

enum PaymentTypeToggles { cash, cheque }

class Voucher extends StatefulWidget {
  static const String routeName = "Voucher";

  @override
  State<Voucher> createState() => _VoucherState();
}

class _VoucherState extends State<Voucher> {
  var _selectedToggleType;
  var _showToggleErrorType = false;
  final List<bool> _selectedOptionType = <bool>[false, false];
  DateTime selectedDate = DateTime.now();
  final TextEditingController _billDateController = TextEditingController();
  List<Account> _accountsData = [];
  List<Transaction> _trans = [];
  final ValueNotifier<double> _notifierCredit = ValueNotifier(0);
  final ValueNotifier<double> _notifierDebit = ValueNotifier(0);
  final ValueNotifier<double> _notifierBalance = ValueNotifier(0);
  final ValueNotifier<String> _notifierAccount = ValueNotifier("");
  final ValueNotifier<bool> _notifierToggleErrorPaymentType =
      ValueNotifier(false);
  final ValueNotifier<String> _notifierTogglePaymentType = ValueNotifier("");
  final ValueNotifier<List<bool>> _notifierSelectedTogglePayment =
      ValueNotifier(<bool>[false, false]);
  @override
  void initState() {
    // TODO: implement initState
    _selectedToggleType = null;
    _showToggleErrorType = false;
    super.initState();
  }

  getData(String accName) {
    double credit = 0;
    double debit = 0;
    for (var element in _trans) {
      if (accName == element.acc_name) {
        if (element.type == "sale" || element.type == "voucher-purchase") {
          credit += double.parse(element.amount.substring(2));
        } else if (element.type == "purchase" ||
            element.type == "voucher-sale") {
          debit += double.parse(element.amount.substring(2));
        }
      }
    }

    _notifierCredit.value = credit;
    _notifierDebit.value = debit;
    _notifierBalance.value = (credit - debit).abs();
  }

  Future<List<Account>> fut() async {
    _accountsData =
        await Provider.of<AccountsProvider>(context, listen: false).accounts;
    _trans =
        await Provider.of<TransactionProvider>(context, listen: false).trans;
    return _accountsData;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    final List<Widget> toggleButtonOptionsType = [
      SizedBox(
        width: 90,
        height: 30,
        child: Center(
          child: Text(
            'Pay',
            style: th.textTheme.bodyMedium,
          ),
        ),
      ),
      SizedBox(
        width: 90,
        height: 30,
        child: Center(
          child: Text(
            'Receive',
            style: th.textTheme.bodyMedium,
          ),
        ),
      ),
    ];
    final List<Widget> toggleButtonOptionsPaymentType = [
      SizedBox(
        width: 90,
        height: 30,
        child: Center(
          child: Text(
            'Cash',
            style: th.textTheme.bodyMedium,
          ),
        ),
      ),
      SizedBox(
        width: 90,
        height: 30,
        child: Center(
          child: Text(
            'Cheque',
            style: th.textTheme.bodyMedium,
          ),
        ),
      ),
    ];
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
          'V O U C H E R',
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
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: ToggleButtons(
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0;
                                  i < _selectedOptionType.length;
                                  i++) {
                                _selectedOptionType[i] = i == index;
                              }
                              if (index == 0) {
                                _selectedToggleType = TypeToggles.pay;
                              } else {
                                _selectedToggleType = TypeToggles.receive;
                              }
                              _showToggleErrorType = false;
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          borderColor: _showToggleErrorType == true
                              ? Colors.redAccent
                              : Colors.grey,
                          selectedBorderColor: th.colorScheme.secondary,
                          selectedColor: Colors.white,
                          fillColor: const Color.fromARGB(255, 23, 23, 23),
                          color: const Color.fromARGB(255, 23, 23, 23),
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 80.0,
                          ),
                          isSelected: _selectedOptionType,
                          children: toggleButtonOptionsType,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 50,
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        Utilities().toastMessage(snapshot.error.toString());
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        return Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: (size.width - 50) / 2,
                                  height: 50,
                                  child: ValueListenableBuilder(
                                    valueListenable: _notifierAccount,
                                    builder: (ctx, value, child) {
                                      return DropdownButton<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'Select an account',
                                            style: th.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: const Color.fromARGB(
                                                        255, 130, 130, 130)),
                                            textAlign: TextAlign.center,
                                          ),
                                          value: _notifierAccount.value == ""
                                              ? null
                                              : _notifierAccount.value,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 136, 78, 236)),
                                          underline: Container(
                                            height: 2,
                                            color: (_showToggleErrorType ==
                                                        true &&
                                                    _notifierAccount.value ==
                                                        "")
                                                ? Colors.redAccent
                                                : Colors.grey,
                                          ),
                                          dropdownColor:
                                              settingsProv.isDark == true
                                                  ? const Color.fromARGB(
                                                      255, 23, 23, 23)
                                                  : Colors.white,
                                          onChanged: (String? value) {
                                            _notifierAccount.value =
                                                value.toString();
                                            getData(_notifierAccount.value);
                                          },
                                          items: data!
                                              .map<DropdownMenuItem<String>>(
                                                  (Account value) {
                                            return DropdownMenuItem<String>(
                                              value: value.acc_name,
                                              child: Text(
                                                "${value.id} - ${value.acc_name}",
                                                style: th.textTheme.bodyMedium,
                                              ),
                                            );
                                          }).toList());
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: ValueListenableBuilder(
                                    valueListenable:
                                        _notifierSelectedTogglePayment,
                                    builder: (ctx, value1, child) {
                                      return ValueListenableBuilder(
                                        valueListenable:
                                            _notifierToggleErrorPaymentType,
                                        builder: (ctx, value2, child) {
                                          return ValueListenableBuilder(
                                            valueListenable:
                                                _notifierTogglePaymentType,
                                            builder: (ctx, value3, child) {
                                              return ToggleButtons(
                                                onPressed: (int index) {
                                                  for (int i = 0;
                                                      i <
                                                          _notifierSelectedTogglePayment
                                                              .value.length;
                                                      i++) {
                                                    _notifierSelectedTogglePayment
                                                        .value[i] = i == index;
                                                  }
                                                  if (index == 0) {
                                                    _notifierTogglePaymentType
                                                            .value =
                                                        PaymentTypeToggles.cash
                                                            .toString();
                                                  } else {
                                                    _notifierTogglePaymentType
                                                            .value =
                                                        PaymentTypeToggles
                                                            .cheque
                                                            .toString();
                                                  }
                                                  _notifierToggleErrorPaymentType
                                                      .value = false;
                                                },
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                                borderColor:
                                                    _notifierToggleErrorPaymentType
                                                                .value ==
                                                            true
                                                        ? Colors.redAccent
                                                        : Colors.grey,
                                                selectedBorderColor:
                                                    th.colorScheme.secondary,
                                                selectedColor: Colors.white,
                                                fillColor: const Color.fromARGB(
                                                    255, 23, 23, 23),
                                                color: const Color.fromARGB(
                                                    255, 23, 23, 23),
                                                constraints:
                                                    const BoxConstraints(
                                                  minHeight: 40.0,
                                                  minWidth: 80.0,
                                                ),
                                                isSelected:
                                                    _notifierSelectedTogglePayment
                                                        .value,
                                                children:
                                                    toggleButtonOptionsPaymentType,
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const Text('Receivable:'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: _notifierCredit,
                                      builder: (ctx, value, child) {
                                        return Text(
                                          value.toString(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    const Text('Payable:'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: _notifierDebit,
                                      builder: (ctx, value, child) {
                                        return Text(
                                          value.toString(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    const Text('Balance:'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: _notifierBalance,
                                      builder: (ctx, value, child) {
                                        return Text(
                                          value.toString(),
                                          style: _notifierCredit.value ==
                                                  _notifierDebit.value
                                              ? TextStyle(
                                                  color:
                                                      th.colorScheme.secondary)
                                              : TextStyle(
                                                  color: _notifierCredit.value >
                                                          _notifierDebit.value
                                                      ? Colors.greenAccent
                                                      : Colors.redAccent),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: (size.width - 40) / 2,
                                  height: 50,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty == true) {
                                        return 'Empty';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      suffixText: "₹",
                                      hintText: "Amount",
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
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: (size.width - 40) / 2,
                                  height: 50,
                                  child: ValueListenableBuilder(
                                    valueListenable: _notifierTogglePaymentType,
                                    builder: (ctx, value, child) {
                                      return TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty == true) {
                                            return 'Empty';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        enabled: value ==
                                            PaymentTypeToggles.cheque
                                                .toString(),
                                        decoration: InputDecoration(
                                          hintText: "Cheque No.",
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
                                              color: Color.fromARGB(
                                                  255, 23, 23, 23),
                                              width: 4.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: 250,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1.0,
                                      color: th.colorScheme.secondary),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.receipt,
                                      color: th.colorScheme.secondary,
                                    ),
                                    Text(
                                      'Generate Voucher',
                                      style: th.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return const Expanded(
                        child: Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                    ));
                  },
                  future: fut(),
                ),
              ],
            ),
          )),
    );
  }
}