import 'package:accouting_software/classes/expense.dart';
import 'package:flutter/foundation.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _exp = [];
  Future<List<Expense>> get exp async {
    await fetch();
    return _exp;
  }

  Future<void> fetch() async {}
}
