import 'package:accouting_software/classes/bill.dart';
import 'package:flutter/material.dart';

class BillProvider with ChangeNotifier {
  List<Bill> _bills = [];
  List<Bill> get bills {
    return _bills;
  }
}
