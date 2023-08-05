import 'package:accouting_software/classes/account_data_object.dart';
import 'package:accouting_software/classes/expense.dart';
import 'package:accouting_software/classes/transactions_stat.dart';
import 'package:accouting_software/providers/expense_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../classes/transaction.dart' as Tran;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  List<Tran.Transaction> _trans = [];
  Future<List<Tran.Transaction>> get trans async {
    await fetch();
    return _trans;
  }

  Future snapshotValue(dataSnapshot) async {
    List<Tran.Transaction> temp = [];
    dataSnapshot.value!.forEach((key, value) {
      Tran.Transaction a = Tran.Transaction(
        name: value['name'],
        acc_name: value['acc_name'],
        type: value['type'],
        amount: value['amount'],
        chequeNo: value['cheque'],
        date: value['date'],
      );
      temp.add(a);
    });
    _trans = temp;
  }

  Future<void> fetch() async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('transactions');
    try {
      final response = await ref.get();
      if (response.value != null) {
        snapshotValue(response);
      } else {
        _trans = [];
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addTransaction(Tran.Transaction t) async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('transactions');
    try {
      await ref.push().set({
        "name": t.name,
        "acc_name": t.acc_name,
        "type": t.type,
        "amount": t.amount,
        "cheque": t.chequeNo,
        "date": t.date,
      });
      _trans.add(t);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<AccountDataObject> dataByAccName(String accountName) async {
    await fetch();
    double credit = 0;
    double debit = 0;
    for (var element in _trans) {
      if (accountName == element.acc_name) {
        if (element.type == "sale" || element.type == "voucher-purchase") {
          credit += double.parse(element.amount.substring(2));
        } else if (element.type == "purchase" ||
            element.type == "voucher-sale") {
          debit += double.parse(element.amount.substring(2));
        }
      }
    }
    return AccountDataObject(credit: credit, debit: debit);
  }

  Future<List<Tran.Transaction>> transByAccName(String accountName) async {
    await fetch();
    List<Tran.Transaction> ls = [];
    for (var element in _trans) {
      if (accountName == element.acc_name) {
        ls.add(element);
      }
    }
    ls.sort(((a, b) => (a.date.compareTo(b.date) * -1)));
    return ls;
  }

  Future<TransStat> stats(
      BuildContext ctx, DateTime start, DateTime end) async {
    await fetch();
    TransStat obj = TransStat();
    double credit = 0;
    double debit = 0;
    double revenue = 0;
    double revMonth = 0;
    double cogs = 0;
    double cogsMonth = 0;
    double profit = 0;
    double profitAvg = 0;
    double profitMonth = 0;
    Map<int, double> cashflow = {};
    for (var element in _trans) {
      var curr = DateFormat.yMd().parse(element.date);
      if ((start.compareTo(curr) < 0 || start.compareTo(curr) == 0) &&
          (end.compareTo(curr) > 0 || end.compareTo(curr) == 0)) {
        // cashflow, revenue and revMonth
        if (element.type == "sale") {
          if (!cashflow.containsKey(curr.month)) {
            cashflow[curr.month] = 0;
          }
          cashflow[curr.month] =
              cashflow[curr.month]! + double.parse(element.amount.substring(2));
          revenue += double.parse(element.amount.substring(2));
          if (curr.month == DateTime.now().month) {
            revMonth += double.parse(element.amount.substring(2));
          }
        }

        if (element.type == "purchase") {
          cogs += double.parse(element.amount.substring(2));
          if (curr.month == DateTime.now().month) {
            cogsMonth += double.parse(element.amount.substring(2));
          }
        }

        // credits total
        if (element.type == "sale" || element.type == "voucher-purchase") {
          credit += double.parse(element.amount.substring(2));
        } // debits total
        else if (element.type == "purchase" || element.type == "voucher-sale") {
          debit += double.parse(element.amount.substring(2));
        }
      }
    }

    List<Expense> ls =
        await Provider.of<ExpenseProvider>(ctx, listen: false).exp;
    for (var each in ls) {
      var curr = DateFormat.yMd().parse(each.date);
      if ((start.compareTo(curr) < 0 || start.compareTo(curr) == 0) &&
          (end.compareTo(curr) > 0 || end.compareTo(curr) == 0)) {
        profit -= double.parse(each.amount);
        if (curr.month == DateTime.now().month) {
          profitMonth -= double.parse(each.amount);
        }
        if (!cashflow.containsKey(curr.month)) {
          cashflow[curr.month] = 0;
        }
        cashflow[curr.month] =
            cashflow[curr.month]! - double.parse(each.amount);
      }
    }
    double sum = 0;
    int count = 0;
    cashflow.forEach((key, value) {
      sum += value;
      count++;
    });
    obj.avg = ((sum) / count).toStringAsFixed(2);
    obj.credit = credit.toStringAsFixed(2);
    obj.debit = debit.toStringAsFixed(2);
    List<List<String>> graphCashFlow = [];
    Map<String, String> temp = {
      "January": "",
      "February": "",
      "March": "",
      "April": "",
      "May": "",
      "June": "",
      "August": "",
      "July": "",
      "September": "",
      "October": "",
      "November": "",
      "December": "",
    };
    cashflow.forEach((key, value) {
      String month = DateFormat('MMMM').format(DateTime(0, key));
      String v = value.toStringAsFixed(2);
      temp[month] = v;
    });
    temp.forEach((key, value) {
      if (value != "") {
        graphCashFlow.add([key, value]);
      }
    });
    obj.graphCashFlow = graphCashFlow;
    int months = (DateTime.now().month - 3);
    obj.revenue = revenue;
    obj.revMonth = revMonth;
    obj.avgRev = months != 0 ? revenue / months : 0;
    obj.cogs = cogs;
    obj.cogsMonth = cogsMonth;
    obj.cogsAverage = months != 0 ? cogs / months : 0;
    obj.profit = profit + revenue - cogs;
    obj.profitMonth = profitMonth + revMonth - cogsMonth;
    // debugPrint(obj.profit.toString());
    // debugPrint(obj.profitMonth.toString());
    // debugPrint(months.toString());
    obj.profitAverage = months != 0 ? obj.profit / months : 0;
    // debugPrint(obj.profitAverage.toString());
    return obj;
  }
}
