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
    onPrimary: Colors.white,
    secondary: Color(0xFF414141),
    onSecondary: Color(0xff2c2c2c),
    tertiary: Color(0xffe4e4e4),
    surface: Colors.white,
    onSurface: Color(0xFF414141),
    onSurfaceVariant: Color(0xff7a7a7a),
    error: Color(0xFFD32F2F),
    onError: Colors.white,
  ),
);
