import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool isDark;
  String units = "";
  String currency = "";
  SettingsProvider(this.isDark);

  void toggleDarkMode(bool v) {
    isDark = v;
  }

  void changeUnits(String u) {
    units = u;
  }

  void changeCurrency(String c) {
    currency = c;
  }

  Future<void> fetch() async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('settings');
    try {
      final response = await ref.get();
      if (response.value != null) {
        debugPrint(response.value.toString());
      } else {
        await pushChanges();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> pushChanges() async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('settings');
    try {
      await ref.set({
        'isdark': isDark,
        'units': units,
        'currency': currency,
      });
    } catch (error) {
      rethrow;
    }
  }
}
