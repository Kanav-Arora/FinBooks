import 'package:accouting_software/classes/account.dart';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/screens/accounts/accounts_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'A D D\nA C C O U N T',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading == true
                ? null
                : () async {
                    _saveForm();
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<AccountsProvider>(context, listen: false)
                        .addAccount(a)
                        .then((_) => Navigator.of(context)
                            .pushReplacementNamed(AccountsMain.routeName));
                  },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
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
                          decoration: const InputDecoration(
                            hintText: "Name",
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
                    decoration: const InputDecoration(
                      hintText: "Email address",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 130, 130, 130)),
                      fillColor: Color.fromARGB(255, 23, 23, 23),
                      filled: true,
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
                    decoration: const InputDecoration(
                      hintText: "Mobile no",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 130, 130, 130)),
                      fillColor: Color.fromARGB(255, 23, 23, 23),
                      filled: true,
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
                    decoration: const InputDecoration(
                      hintText: "Address",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 130, 130, 130)),
                      fillColor: Color.fromARGB(255, 23, 23, 23),
                      filled: true,
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
                          decoration: const InputDecoration(
                            hintText: "City",
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
                          decoration: const InputDecoration(
                            hintText: "State",
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
                          decoration: const InputDecoration(
                            hintText: "Pincode",
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
                          decoration: const InputDecoration(
                            hintText: "Credit days",
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
                          decoration: const InputDecoration(
                            hintText: "GST No.",
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
                          decoration: const InputDecoration(
                            hintText: "PAN No.",
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
                    height: 20,
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
