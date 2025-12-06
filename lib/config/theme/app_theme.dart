import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;

  AppTheme({this.isDarkMode = false});

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Color(0XFF0000FF),
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
  );
}
