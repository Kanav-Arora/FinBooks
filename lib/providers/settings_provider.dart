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
}
