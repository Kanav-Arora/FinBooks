import 'package:accouting_software/screens/accounts/accounts_main.dart';
import 'package:accouting_software/screens/sale/add_sale.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/account.dart';

enum Toggles { all, credit, debit }

class AccountsProvider with ChangeNotifier {
  List<Account> _account = [];
  List<Account> get accounts {
    return _account;
  }

  Future<void> addAccount(Account a) async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    var id = a.id.toString();
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('accounts').child(id);
    try {
      await ref.set({
        "acc_name": a.acc_name,
        "acc_type": a.acc_type,
        "address": a.address,
        "city": a.city,
        "state": a.state,
        "pincode": a.pincode,
        "gst_no": a.gst_no,
        "pan_no": a.pan_no,
        "email": a.email,
        "mobile_no": a.mobile_no,
        "credit_days": a.credit_days,
        "interest_rate": a.interest_rate,
      });
      _account.add(a);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future snapshotValue(dataSnapshot) async {
    List<Account> temp = [];
    dataSnapshot.value!.forEach((key, value) {
      Account a = Account(
        id: key,
        acc_name: value['acc_name'],
        acc_type: value['acc_type'],
        address: value['address'],
        city: value['city'],
        state: value['state'],
        pincode: value['pincode'],
        gst_no: value['gst_no'],
        pan_no: value['pan_no'],
        email: value['email'],
        mobile_no: value['mobile_no'],
        credit_days: value['credit_days'],
        interest_rate: value['interest_rate'],
      );
      temp.add(a);
    });
    temp.sort(((a, b) => a.acc_name.compareTo(b.acc_name)));
    _account = temp;
  }

  Future<void> fetch() async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('accounts');
    try {
      final response = await ref.get();
      if (response.value != null) {
        snapshotValue(response);
      } else {
        _account = [];
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Account>> toggled(String t) async {
    List<Account> newList = [];
    await fetch();
    if (t == Toggles.all.name) {
      newList = accounts;
    } else {
      for (var element in accounts) {
        if (t == Toggles.credit.name &&
            element.acc_type == Toggles.credit.name) {
          newList.add(element);
        } else if (t == Toggles.debit.name &&
            element.acc_type == Toggles.debit.name) {
          newList.add(element);
        }
      }
    }
    return newList;
  }
}
