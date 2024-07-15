import 'package:flutter/material.dart';


const primaryColor = Color(0xFF3F51B5); // #0B141A


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);