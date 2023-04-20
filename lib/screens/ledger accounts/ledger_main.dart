import 'package:accouting_software/classes/account.dart';
import 'package:accouting_software/classes/transaction.dart';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:accouting_software/screens/app_drawer.dart';
import 'package:accouting_software/widgets/app_bar_popupmenubutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../icons/custom_icons_icons.dart';
import '../../utils/utitlities.dart';

class LedgerMain extends StatefulWidget {
  static const String routeName = "LedgerMain";

  @override
  State<LedgerMain> createState() => _LedgerMainState();
}

class _LedgerMainState extends State<LedgerMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late var _selectedValue;
  List<Transaction> listTrans = [];
  var _isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    _selectedValue = null;
    _isloading = false;
    super.initState();
  }

  Widget listItem(ThemeData th, Transaction b) {
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
                b.name,
                style: th.textTheme.bodyMedium,
              ),
              Text(
                b.amount,
                style: th.textTheme.bodyMedium!.copyWith(
                    color: b.type == "sale"
                        ? Colors.greenAccent
                        : Colors.redAccent),
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
                "Date: ${b.date}",
                style: th.textTheme.bodySmall,
              ),
              b.chequeNo.isNotEmpty
                  ? Text(
                      "Cheque No: ${b.chequeNo}",
                      style: th.textTheme.bodySmall,
                    )
                  : const Text(''),
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
          'L E D G E R\nA C C O U N T S',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: const [AppBarPopupmenuButton()],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              FutureBuilder(
                builder: ((ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      Utilities().toastMessage(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      var data = snapshot.data as List<Account>;
                      return DropdownButton<String>(
                          hint: Text(
                            'Select an account',
                            style: th.textTheme.bodyMedium!.copyWith(
                                color:
                                    const Color.fromARGB(255, 130, 130, 130)),
                            textAlign: TextAlign.center,
                          ),
                          value: _selectedValue,
                          elevation: 16,
                          dropdownColor: const Color.fromARGB(255, 23, 23, 23),
                          items: data
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e.acc_name,
                                  child: Text(e.acc_name),
                                ),
                              )
                              .toList(),
                          onChanged: ((value) async {
                            setState(() {
                              _isloading = true;
                            });
                            listTrans = await Provider.of<TransactionProvider>(
                                    context,
                                    listen: false)
                                .transByAccName(value.toString());
                            setState(() {
                              _selectedValue = value;
                              _isloading = false;
                            });
                          }));
                    }
                  }
                  return const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)));
                }),
                future: Provider.of<AccountsProvider>(context, listen: false)
                    .accounts,
              ),
              _selectedValue != null
                  ? _isloading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white)))
                      : Expanded(
                          child: listTrans.isNotEmpty
                              ? ListView.builder(
                                  itemBuilder: ((ctx, index) {
                                    Transaction t = listTrans.elementAt(index);
                                    return listItem(th, t);
                                  }),
                                  itemCount: listTrans.length,
                                )
                              : const Center(
                                  child: Text('No transactions to show'),
                                ))
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
