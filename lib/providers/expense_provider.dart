import 'package:accouting_software/classes/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _exp = [];
  Map<String, List<Expense>> _catexp = {};
  Future<List<Expense>> get exp async {
    await fetch();
    return _exp;
  }

  Future<Map<String, List<Expense>>> get catexp async {
    await fetch();
    return _catexp;
  }

  Future snapshotValue(dataSnapshot) async {
    List<Expense> tempexp = [];
    Map<String, List<Expense>> tempcat = {};
    dataSnapshot.value!.forEach((key1, value1) {
      value1!.forEach((key2, value2) {
        Expense e = Expense(
            category: key1,
            date: value2['date'],
            amount: value2['amount'],
            message: value2['message']);
        tempexp.add(e);
      });
    });
    _exp = tempexp;
    _exp.sort((a, b) => (a.date.compareTo(b.date) * -1));
    for (var element in _exp) {
      if (!tempcat.containsKey(element.category)) {
        tempcat[element.category] = [];
      }
      tempcat[element.category]!.add(element);
    }
    _catexp = tempcat;
  }

  Future<void> fetch() async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('operatingexp');
    try {
      final response = await ref.get();
      if (response.value != null) {
        snapshotValue(response);
      } else {
        _exp = [];
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addExpense(Expense e) async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance
        .ref('user/$user')
        .child('operatingexp')
        .child(e.category);
    try {
      await ref
          .push()
          .set({"date": e.date, "amount": e.amount, "message": e.message});
      _exp.add(e);
      _catexp[e.category]!.add(e);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<double>> expenseData() async {
    List<double> ret = [];
    await fetch();
    var curr = DateTime.now();
    var minus = 0;
    if (curr.month <= 3) {
      minus = 1;
    }
    var fiscalStart = DateTime(DateTime.now().year - minus, 4, 1);
    var fiscalEnd = DateTime(DateTime.now().year + (minus == 1 ? 0 : 1), 3, 31);
    double totalExpenseofMonth = 0.0;
    double totalExpenseofLastMonth = 0.0;
    double totalExpenseofFiscalYear = 0.0;
    for (var ele in _exp) {
      var eleDate = DateFormat.yMd().parse(ele.date);
      if ((fiscalStart.compareTo(eleDate) < 0 ||
              fiscalStart.compareTo(eleDate) == 0) &&
          (fiscalEnd.compareTo(eleDate) > 0 ||
              fiscalEnd.compareTo(eleDate) == 0)) {
        totalExpenseofFiscalYear += double.parse(ele.amount);
      }
      if (eleDate.month == curr.month) {
        totalExpenseofMonth += double.parse(ele.amount);
      }
      if (eleDate.month == curr.month - 1) {
        totalExpenseofLastMonth += double.parse(ele.amount);
      }
    }
    ret = [
      totalExpenseofMonth,
      totalExpenseofLastMonth,
      totalExpenseofFiscalYear
    ];
    return ret;
  }

  List<double> expenseDataByList(List<Expense> ls) {
    List<double> ret = [];
    var curr = DateTime.now();
    var minus = 0;
    if (curr.month <= 3) {
      minus = 1;
    }
    var fiscalStart = DateTime(DateTime.now().year - minus, 4, 1);
    var fiscalEnd = DateTime(DateTime.now().year + (minus == 1 ? 0 : 1), 3, 31);
    double totalExpenseofMonth = 0.0;
    double totalExpenseofLastMonth = 0.0;
    double totalExpenseofFiscalYear = 0.0;
    for (var ele in ls) {
      var eleDate = DateFormat.yMd().parse(ele.date);
      if ((fiscalStart.compareTo(eleDate) < 0 ||
              fiscalStart.compareTo(eleDate) == 0) &&
          (fiscalEnd.compareTo(eleDate) > 0 ||
              fiscalEnd.compareTo(eleDate) == 0)) {
        totalExpenseofFiscalYear += double.parse(ele.amount);
      }
      if (eleDate.month == curr.month) {
        totalExpenseofMonth += double.parse(ele.amount);
      }
      if (eleDate.month == curr.month - 1) {
        totalExpenseofLastMonth += double.parse(ele.amount);
      }
    }
    ret = [
      totalExpenseofMonth,
      totalExpenseofLastMonth,
      totalExpenseofFiscalYear
    ];
    return ret;
  }
}
