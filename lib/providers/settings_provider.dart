import 'package:adaptive_theme/adaptive_theme.dart';
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

  Future snapshotValue(dataSnapshot, BuildContext context) async {
    var val = dataSnapshot.value['isdark'] as bool;
    if (val != isDark) {
      isDark = val;
      isDark == true
          ? AdaptiveTheme.of(context).setDark()
          : AdaptiveTheme.of(context).setLight();
    }
    units = dataSnapshot.value['units'] as String;
    currency = dataSnapshot.value['currency'] as String;
  }

  Future<void> fetch(BuildContext ctx) async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('settings');
    try {
      final response = await ref.get();
      if (response.value != null) {
        snapshotValue(response, ctx);
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
