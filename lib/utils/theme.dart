import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black, fontSize: 22),
      labelMedium: TextStyle(color: Colors.black, fontSize: 18),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 15),
      bodySmall: TextStyle(color: Colors.black, fontSize: 12),
      titleMedium: TextStyle(color: Colors.black),
    ),
    colorScheme: ThemeData().colorScheme.copyWith(secondary: Colors.black),
    iconTheme: const IconThemeData(color: Colors.black, opacity: 1.0),
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 35,
      ),
    ),
  );
  static final dark = ThemeData.dark().copyWith(
      primaryColor: const Color.fromARGB(255, 16, 16, 16),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 22),
        labelMedium: TextStyle(color: Colors.white, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.white, fontSize: 15),
        bodySmall: TextStyle(color: Colors.white, fontSize: 12),
        titleMedium: TextStyle(color: Colors.white),
      ),
      colorScheme: ThemeData().colorScheme.copyWith(secondary: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white, opacity: 1.0),
      appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 16, 16, 16),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 35)));
}
