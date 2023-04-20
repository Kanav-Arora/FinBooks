import 'package:accouting_software/classes/account.dart';
import 'package:accouting_software/classes/item.dart';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/providers/cart_provider.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../classes/bill.dart';
import '../../icons/custom_icons_icons.dart';
import '../../widgets/app_bar_popupmenubutton.dart';
import '../app_drawer.dart';
import '../cart_screen.dart';

enum Toggles { cash, credit }

class AddSale extends StatefulWidget {
  static const String routeName = "AddSale";

  @override
  State<AddSale> createState() => _AddSaleState();
}

class _AddSaleState extends State<AddSale> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<bool> _selectedOption = <bool>[false, false];
  var _selectedToggle;
  DateTime selectedDate = DateTime.now();
  DateTime dueDate = DateTime.now();
  final TextEditingController _billDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  late var _selectedAccount;
  late Account _userAcc;
  late var _selectedItem;
  late Item _itemObj;
  final _formKey = GlobalKey<FormState>();
  Bill argObject = Bill(
    billNo: "",
    paymentType: "",
    accName: "",
    billDate: "",
    dueDate: "",
    billType: "sale",
  );
  var _showToggleError = false;

  @override
  void initState() {
    _selectedToggle = null;
    _selectedAccount = null;
    _showToggleError = false;
    _userAcc = Account(
      id: "",
      acc_name: "",
      address: "",
      city: "",
      state: "",
      pincode: "",
      gst_no: "",
      pan_no: "",
      email: "",
      mobile_no: "",
      credit_days: "",
      interest_rate: "",
    );
    _selectedItem = null;
    _itemObj = Item(
      id: "",
      name: "",
      gstSlab: "",
      quantity: "",
      price: "",
    );
    super.initState();
  }

  void getAcc(String val) {
    setState(() {
      _userAcc = Provider.of<AccountsProvider>(context, listen: false)
          .accountByName(val);
    });
    dueDate = selectedDate.add(
      Duration(
        days: int.parse(_userAcc.credit_days),
      ),
    );
    _billDateController.text = DateFormat.yMd().format(selectedDate);
    _dueDateController.text = DateFormat.yMd().format(dueDate);
  }

  void getItemByName(String item) {
    setState(() {
      _itemObj =
          Provider.of<ItemProvider>(context, listen: false).getItemByName(item);
    });
    _priceController.text = _itemObj.price;
    _gstController.text = _itemObj.gstSlab;
  }

  bool _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedToggle == null || _selectedAccount == null) {
      setState(() {
        _showToggleError = true;
      });
      return false;
    }
    _formKey.currentState!.save();
    argObject = Bill(
        billNo: argObject.billNo,
        paymentType: (_selectedToggle as Toggles).name,
        accName: _selectedAccount,
        billDate: _billDateController.text,
        dueDate: _dueDateController.text,
        billType: argObject.billType);
    return true;
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
        actions: const [AppBarPopupmenuButton()],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: th.primaryColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: (size.width - 20) / 2,
                        child: TextFormField(
                          onSaved: (newValue) {
                            argObject = Bill(
                                billNo: newValue.toString(),
                                paymentType: argObject.paymentType,
                                accName: argObject.accName,
                                billDate: argObject.billDate,
                                dueDate: argObject.dueDate,
                                billType: argObject.billType);
                          },
                          validator: (value) {
                            if (value!.isEmpty == true) {
                              return 'Empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Id",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: Color.fromARGB(255, 23, 23, 23),
                            filled: true,
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
                            _showToggleError = false;
                          });
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderColor:
                            _showToggleError == true && _selectedItem == null
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
                        isSelected: _selectedOption,
                        children: toggleButtonOptions,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: size.width,
                    child: FutureBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            Utilities().toastMessage(snapshot.error.toString());
                          } else if (snapshot.hasData) {
                            final data = snapshot.data;
                            return SizedBox(
                              height: 50,
                              child: DropdownButton<String>(
                                  hint: Text(
                                    'Select an account',
                                    style: th.textTheme.bodyMedium!.copyWith(
                                        color: const Color.fromARGB(
                                            255, 130, 130, 130)),
                                    textAlign: TextAlign.center,
                                  ),
                                  value: _selectedAccount,
                                  icon: const Icon(
                                    Icons.arrow_downward,
                                    color: Color.fromARGB(255, 130, 130, 130),
                                  ),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: (_showToggleError == true &&
                                            _selectedAccount == null)
                                        ? Colors.redAccent
                                        : Colors.grey,
                                  ),
                                  dropdownColor:
                                      const Color.fromARGB(255, 23, 23, 23),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedAccount = value ?? "";
                                    });
                                    getAcc(_selectedAccount);
                                  },
                                  items: data!.map<DropdownMenuItem<String>>(
                                      (Account value) {
                                    return DropdownMenuItem<String>(
                                      value: value.acc_name,
                                      child: Text(
                                        value.acc_name,
                                        style: th.textTheme.bodyMedium,
                                      ),
                                    );
                                  }).toList()),
                            );
                          }
                        }
                        return SizedBox(
                            height: 50,
                            child: DropdownButton<String>(
                              onChanged: null,
                              underline: Container(
                                height: 2,
                                color: Colors.grey,
                              ),
                              hint: Text(
                                'Select an account',
                                style: th.textTheme.bodyMedium!.copyWith(
                                    color: const Color.fromARGB(
                                        255, 130, 130, 130)),
                                textAlign: TextAlign.center,
                              ),
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              dropdownColor:
                                  const Color.fromARGB(255, 23, 23, 23),
                              items: const [],
                            ));
                      },
                      future:
                          Provider.of<AccountsProvider>(context, listen: false)
                              .accounts,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
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
                              decoration: const InputDecoration(
                                hintText: "dd/mm/yy",
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 130, 130, 130)),
                                fillColor: Color.fromARGB(255, 23, 23, 23),
                                filled: true,
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
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: dueDate,
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime(2101));
                                if (picked != null && picked != dueDate) {
                                  setState(() {
                                    dueDate = picked;
                                    _dueDateController.text =
                                        DateFormat.yMd().format(dueDate);
                                  });
                                }
                              },
                              controller: _dueDateController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: "dd/mm/yy",
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 130, 130, 130)),
                                fillColor: Color.fromARGB(255, 23, 23, 23),
                                filled: true,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Divider(
                    height: 20,
                    color: th.colorScheme.secondary,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: SizedBox(
                      width: size.width,
                      child: FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              Utilities()
                                  .toastMessage(snapshot.error.toString());
                            } else if (snapshot.hasData) {
                              final data = snapshot.data;
                              return DropdownButton<String>(
                                  hint: Text(
                                    'Select an item',
                                    style: th.textTheme.bodyMedium!.copyWith(
                                        color: const Color.fromARGB(
                                            255, 130, 130, 130)),
                                    textAlign: TextAlign.center,
                                  ),
                                  value: _selectedItem,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  dropdownColor:
                                      const Color.fromARGB(255, 23, 23, 23),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedItem = value ?? "";
                                    });
                                    getItemByName(_selectedItem);
                                  },
                                  items: data!.map<DropdownMenuItem<String>>(
                                      (Item value) {
                                    return DropdownMenuItem<String>(
                                      value: value.name,
                                      child: Text(
                                        value.name,
                                        style: th.textTheme.bodyMedium,
                                      ),
                                    );
                                  }).toList());
                            }
                          }
                          return DropdownButton<String>(
                              hint: Text(
                                'Select an item',
                                style: th.textTheme.bodyMedium!.copyWith(
                                    color: const Color.fromARGB(
                                        255, 130, 130, 130)),
                                textAlign: TextAlign.center,
                              ),
                              value: _selectedItem,
                              icon: const Icon(
                                Icons.arrow_downward,
                                color: Color.fromARGB(255, 130, 130, 130),
                              ),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.grey,
                              ),
                              dropdownColor:
                                  const Color.fromARGB(255, 23, 23, 23),
                              onChanged: null,
                              items: const []);
                        },
                        future:
                            Provider.of<ItemProvider>(context, listen: false)
                                .items,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: (size.width - 40) / 2,
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: "Price",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: const Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                            hoverColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          enabled: false,
                          controller: _gstController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: "GST (Fixed)",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: const Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                            hoverColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: (size.width - 40) / 2,
                        child: TextFormField(
                          controller: _quantityController,
                          validator: ((value) {
                            if (_selectedItem == null) return null;
                            if (double.parse(_itemObj.quantity) <
                                double.parse(_quantityController.text)) {
                              return 'Insufficient stock: ${_itemObj.quantity}';
                            }
                            return null;
                          }),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: "Quantity",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _discountController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: "Discount(%)",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: (size.width - 40) / 2,
                        child: OutlinedButton(
                          onPressed: () {
                            bool check = _saveForm();
                            if (!check) return;
                            Navigator.of(context).pushNamed(
                                CartScreen.routeName,
                                arguments: argObject);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1.0, color: th.colorScheme.secondary),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                color: th.colorScheme.secondary,
                              ),
                              Text(
                                'Checkout',
                                style: th.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _selectedItem == null
                              ? null
                              : () {
                                  final isValid =
                                      _formKey.currentState!.validate();
                                  if (!isValid) return;
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .add(
                                          _selectedItem,
                                          _priceController.text,
                                          _quantityController.text,
                                          _discountController.text == ""
                                              ? "0"
                                              : _discountController.text,
                                          _gstController.text);
                                  setState(() {
                                    _selectedItem = null;
                                  });
                                  _quantityController.text = "";
                                  _discountController.text = "";
                                  _priceController.text = "";
                                  _gstController.text = "";
                                },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1.0,
                                color: _selectedItem == null
                                    ? Colors.grey
                                    : th.colorScheme.secondary),
                          ),
                          child: Text(
                            'Add Item',
                            style: th.textTheme.bodyMedium!.copyWith(
                                color: _selectedItem == null
                                    ? Colors.grey
                                    : th.colorScheme.secondary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
