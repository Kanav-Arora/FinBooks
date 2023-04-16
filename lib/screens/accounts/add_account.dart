import 'package:accouting_software/classes/account.dart';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/screens/accounts/accounts_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../icons/custom_icons_icons.dart';
import '../../widgets/app_bar_popupmenubutton.dart';
import '../app_drawer.dart';

enum Toggles { all, sale, purchase }

class AddAccount extends StatefulWidget {
  static const String routeName = "AddAccount";

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _isLoading = false;
  final List<bool> _selectedOption = <bool>[false, false];
  var _selectedToggle = Toggles.sale;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _selectedToggle = Toggles.purchase;
    _isLoading = false;
    super.initState();
  }

  Account a = Account(
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
      credit_days: "0",
      interest_rate: "");

  void _saveForm() {
    _formkey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final List<Widget> toggleButtonOptions = [
      Text(
        'Sale',
        style: th.textTheme.bodyMedium,
      ),
      Text(
        'Purchase',
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
          'A D D\nA C C O U N T',
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
              key: _formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 5,
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Account(
                                id: newValue.toString(),
                                acc_name: a.acc_name,
                                address: a.address,
                                city: a.city,
                                state: a.state,
                                pincode: a.pincode,
                                gst_no: a.gst_no,
                                pan_no: a.pan_no,
                                email: a.email,
                                mobile_no: a.mobile_no,
                                credit_days: a.credit_days,
                                interest_rate: a.interest_rate);
                          },
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
                      Expanded(
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Account(
                                id: a.id,
                                acc_name: newValue.toString(),
                                address: a.address,
                                city: a.city,
                                state: a.state,
                                pincode: a.pincode,
                                gst_no: a.gst_no,
                                pan_no: a.pan_no,
                                email: a.email,
                                mobile_no: a.mobile_no,
                                credit_days: a.credit_days,
                                interest_rate: a.interest_rate);
                          },
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Name",
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
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      a = Account(
                          id: a.id,
                          acc_name: a.acc_name,
                          address: a.address,
                          city: a.city,
                          state: a.state,
                          pincode: a.pincode,
                          gst_no: a.gst_no,
                          pan_no: a.pan_no,
                          email: newValue.toString(),
                          mobile_no: a.mobile_no,
                          credit_days: a.credit_days,
                          interest_rate: a.interest_rate);
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Email address",
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      a = Account(
                          id: a.id,
                          acc_name: a.acc_name,
                          address: a.address,
                          city: a.city,
                          state: a.state,
                          pincode: a.pincode,
                          gst_no: a.gst_no,
                          pan_no: a.pan_no,
                          email: a.email,
                          mobile_no: newValue.toString(),
                          credit_days: a.credit_days,
                          interest_rate: a.interest_rate);
                    },
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Mobile no",
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      a = Account(
                          id: a.id,
                          acc_name: a.acc_name,
                          address: newValue.toString(),
                          city: a.city,
                          state: a.state,
                          pincode: a.pincode,
                          gst_no: a.gst_no,
                          pan_no: a.pan_no,
                          email: a.email,
                          mobile_no: a.mobile_no,
                          credit_days: a.credit_days,
                          interest_rate: a.interest_rate);
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Address",
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 2.5,
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Account(
                                id: a.id,
                                acc_name: a.acc_name,
                                address: a.address,
                                city: newValue.toString(),
                                state: a.state,
                                pincode: a.pincode,
                                gst_no: a.gst_no,
                                pan_no: a.pan_no,
                                email: a.email,
                                mobile_no: a.mobile_no,
                                credit_days: a.credit_days,
                                interest_rate: a.interest_rate);
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "City",
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
                      Expanded(
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Account(
                                id: a.id,
                                acc_name: a.acc_name,
                                address: a.address,
                                city: a.city,
                                state: newValue.toString(),
                                pincode: a.pincode,
                                gst_no: a.gst_no,
                                pan_no: a.pan_no,
                                email: a.email,
                                mobile_no: a.mobile_no,
                                credit_days: a.credit_days,
                                interest_rate: a.interest_rate);
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "State",
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
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: (size.width - 20) / 2,
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Account(
                                id: a.id,
                                acc_name: a.acc_name,
                                address: a.address,
                                city: a.city,
                                state: a.state,
                                pincode: newValue.toString(),
                                gst_no: a.gst_no,
                                pan_no: a.pan_no,
                                email: a.email,
                                mobile_no: a.mobile_no,
                                credit_days: a.credit_days,
                                interest_rate: a.interest_rate);
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Pincode",
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
                      Expanded(
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Account(
                                id: a.id,
                                acc_name: a.acc_name,
                                address: a.address,
                                city: a.city,
                                state: a.state,
                                pincode: a.pincode,
                                gst_no: a.gst_no,
                                pan_no: a.pan_no,
                                email: a.email,
                                mobile_no: a.mobile_no,
                                credit_days: newValue.toString(),
                                interest_rate: a.interest_rate);
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Credit days",
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
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: (size.width - 20) / 2,
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Account(
                                id: a.id,
                                acc_name: a.acc_name,
                                address: a.address,
                                city: a.city,
                                state: a.state,
                                pincode: a.pincode,
                                gst_no: newValue.toString(),
                                pan_no: a.pan_no,
                                email: a.email,
                                mobile_no: a.mobile_no,
                                credit_days: a.credit_days,
                                interest_rate: a.interest_rate);
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "GST No.",
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
                      Expanded(
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Account(
                                id: a.id,
                                acc_name: a.acc_name,
                                address: a.address,
                                city: a.city,
                                state: a.state,
                                pincode: a.pincode,
                                gst_no: a.gst_no,
                                pan_no: newValue.toString(),
                                email: a.email,
                                mobile_no: a.mobile_no,
                                credit_days: a.credit_days,
                                interest_rate: a.interest_rate);
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "PAN No.",
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
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      _saveForm();
                      setState(() {
                        _isLoading = true;
                      });
                      await Provider.of<AccountsProvider>(context,
                              listen: false)
                          .addAccount(a)
                          .then((_) => Navigator.of(context)
                              .pushReplacementNamed(AccountsMain.routeName));
                    },
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 181, 21, 221),
                            Color.fromARGB(255, 211, 40, 168),
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                      child: Center(
                        child: _isLoading == true
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                      ),
                    ),
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
