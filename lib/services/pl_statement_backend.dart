import 'package:accouting_software/classes/pl_stat.dart';
import 'package:accouting_software/providers/expense_provider.dart';
import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PLStatementBackend {
  Future<Map<String, PLStat>> getData(BuildContext context) async {
    final transProv = Provider.of<TransactionProvider>(context, listen: false);
    try {
      var data = await transProv.trans;
      Map<String, PLStat> dataByYear = {};
      for (var each in data) {
        if (each.type == "sale") {
          var date = DateFormat.yMd().parse(each.date);
          String yr = "";
          if (date.isBefore(DateTime(date.year, 4, 1))) {
            yr = "${date.year - 1}-${date.year}";
          } else {
            yr = "${date.year}-${date.year + 1}";
          }
          if (!dataByYear.containsKey(yr)) dataByYear[yr] = PLStat();
          dataByYear[yr]!.sales =
              dataByYear[yr]!.sales + double.parse(each.amount.substring(2));
        }
        if (each.type == "purchase") {
          var date = DateFormat.yMd().parse(each.date);
          String yr = "";
          if (date.isBefore(DateTime(date.year, 4, 1))) {
            yr = "${date.year - 1}-${date.year}";
          } else {
            yr = "${date.year}-${date.year + 1}";
          }
          if (!dataByYear.containsKey(yr)) dataByYear[yr] = PLStat();
          dataByYear[yr]!.cogs =
              dataByYear[yr]!.cogs + double.parse(each.amount.substring(2));
        }
      }
      dataByYear.forEach((key, value) {
        dataByYear[key]!.gross_profit =
            dataByYear[key]!.sales - dataByYear[key]!.cogs;
      });

      final expenseProv = Provider.of<ExpenseProvider>(context, listen: false);

      final Map<String, double> expenseByCat;
      final expenseData = await expenseProv.catexp;
      expenseData.forEach((key, value) {
        for (var element in value) {
          var date = DateFormat.yMd().parse(element.date);
          String yr = "";
          if (date.isBefore(DateTime(date.year, 4, 1))) {
            yr = "${date.year - 1}-${date.year}";
          } else {
            yr = "${date.year}-${date.year + 1}";
          }

          if (!dataByYear.containsKey(yr)) {
            dataByYear[yr] = PLStat();
          }
          if (!dataByYear[yr]!.expenseCat.containsKey(element.category)) {
            dataByYear[yr]!.expenseCat[element.category] = 0.0;
          }

          dataByYear[yr]!.expenseCat[element.category] =
              dataByYear[yr]!.expenseCat[element.category]! +
                  double.parse(element.amount);
          dataByYear[yr]!.expenseTotal += double.parse(element.amount);
        }
      });

      return dataByYear;
    } catch (error) {
      rethrow;
    }
  }
}
