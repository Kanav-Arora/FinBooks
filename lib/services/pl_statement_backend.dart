import 'package:accouting_software/classes/pl_stat.dart';
import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PLStatementBackend {
  Future<Map<String, PLStat>> getData(BuildContext context) async {
    final transProv = Provider.of<TransactionProvider>(context, listen: false);
    try {
      var data = await transProv.trans;
      Map<String, PLStat> salesByYear = {};
      for (var each in data) {
        if (each.type == "sale") {
          var date = DateFormat.yMd().parse(each.date);
          String yr = "";
          if (date.isBefore(DateTime(date.year, 4, 1))) {
            yr = "${date.year - 1}-${date.year}";
          } else {
            yr = "${date.year}-${date.year + 1}";
          }
          if (!salesByYear.containsKey(yr)) salesByYear[yr] = PLStat();
          salesByYear[yr]!.sales =
              salesByYear[yr]!.sales + double.parse(each.amount.substring(2));
        }
        if (each.type == "purchase") {
          var date = DateFormat.yMd().parse(each.date);
          String yr = "";
          if (date.isBefore(DateTime(date.year, 4, 1))) {
            yr = "${date.year - 1}-${date.year}";
          } else {
            yr = "${date.year}-${date.year + 1}";
          }
          if (!salesByYear.containsKey(yr)) salesByYear[yr] = PLStat();
          salesByYear[yr]!.cogs =
              salesByYear[yr]!.cogs + double.parse(each.amount.substring(2));
        }
      }
      salesByYear.forEach((key, value) {
        salesByYear[key]!.gross_profit =
            salesByYear[key]!.sales - salesByYear[key]!.cogs;
      });
      return salesByYear;
    } catch (error) {
      rethrow;
    }
  }
}
