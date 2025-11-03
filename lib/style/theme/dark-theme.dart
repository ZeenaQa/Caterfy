import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: Typography().white.apply(fontFamily: "DM Sans"),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade900,
    hintStyle: const TextStyle(color: Colors.white54),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9359FF),
    primaryContainer: Color(0xFF3F1E6F),
    secondary: Color(0xFF90A4AE),
    secondaryContainer: Color(0xFF37474F),
    surface: Color(0xFF1E1E1E),
    background: Color(0xFF121212),
    error: Color(0xFFEF5350),
    onPrimary: Colors.white,
    onSecondary: Colors.white70,
    onSurface: Colors.white70,
    onError: Colors.black,
  ),
);
