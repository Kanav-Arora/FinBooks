import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    textTheme: TextTheme(
      titleLarge: const TextStyle(color: Colors.black, fontSize: 22),
      labelMedium: const TextStyle(color: Colors.black, fontSize: 18),
      bodyMedium: const TextStyle(color: Colors.black, fontSize: 15),
      bodySmall: const TextStyle(color: Colors.black, fontSize: 12),
      titleMedium: const TextStyle(color: Colors.black),
      labelSmall: ThemeData().textTheme.labelSmall!.copyWith(fontSize: 16),
      labelLarge: ThemeData().textTheme.labelSmall!.copyWith(fontSize: 22),
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
      textTheme: TextTheme(
        titleLarge: const TextStyle(color: Colors.white, fontSize: 22),
        labelMedium: const TextStyle(color: Colors.white, fontSize: 18),
        bodyMedium: const TextStyle(color: Colors.white, fontSize: 15),
        bodySmall: const TextStyle(color: Colors.white, fontSize: 12),
        titleMedium: const TextStyle(color: Colors.white),
        labelSmall: ThemeData()
            .textTheme
            .labelSmall!
            .copyWith(fontSize: 16, color: Colors.white),
        labelLarge: ThemeData()
            .textTheme
            .labelLarge!
            .copyWith(fontSize: 22, color: Colors.white),
      ),
      colorScheme: ThemeData().colorScheme.copyWith(secondary: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white, opacity: 1.0),
      appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 16, 16, 16),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 35)));
}
