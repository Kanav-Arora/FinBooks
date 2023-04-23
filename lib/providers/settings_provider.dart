import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool isDark;
  SettingsProvider(this.isDark);
  String units = "units";

  void toggleDarkMode(bool v) {
    isDark = v;
  }
}
