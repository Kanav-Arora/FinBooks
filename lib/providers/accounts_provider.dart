import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/account.dart';

class AccountsProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Account> _account = [
    Account(
      id: "A1",
      acc_name: "Bajaj Traders",
      acc_type: "Credit",
      address: "Shastri Nagar",
      city: "Ludhiana",
      state: "Punjab",
      pincode: "141002",
      gst_no: "ABN098",
      pan_no: "AN340",
      email: "kanavarora1515@gmail.com",
      mobile_no: "9814025823",
      credit_days: "20",
      interest_rate: "12",
    ),
    Account(
      id: "A2",
      acc_name: "Laal Traders",
      acc_type: "Credit",
      address: "Shastri Nagar",
      city: "Ludhiana",
      state: "Punjab",
      pincode: "141002",
      gst_no: "ABN098",
      pan_no: "AN340",
      email: "kanavarora1515@gmail.com",
      mobile_no: "9814025823",
      credit_days: "20",
      interest_rate: "12",
    ),
  ];

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
}
