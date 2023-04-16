import 'package:accouting_software/classes/account_data_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      debugPrint(error.toString());
      rethrow;
    }
  }

  AccountDataObject dataByAccName(String accountName) {
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
}
