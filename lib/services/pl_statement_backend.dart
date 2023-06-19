import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PLStatementBackend {
  Future<Map<int, double>> getData(BuildContext context) async {
    final transProv = Provider.of<TransactionProvider>(context, listen: false);
    try {
      var data = await transProv.trans;
      Map<int, double> salesByYear = {};
      for (var each in data) {
        if (each.type == "sale") {
          var yr = DateFormat.yMd().parse(each.date).year;
          if (!salesByYear.containsKey(yr)) salesByYear[yr] = 0;
          salesByYear[yr] =
              salesByYear[yr]! + double.parse(each.amount.substring(2));
        }
      }
      for (int i = 2000; i < 2008; i++) {
        salesByYear.putIfAbsent(i, () => 0.0);
      }
      return salesByYear;
    } catch (error) {
      rethrow;
    }
  }
}
