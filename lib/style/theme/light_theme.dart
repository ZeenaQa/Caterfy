import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  textTheme: Typography().black.apply(fontFamily: "DM Sans"),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: Colors.black54),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
    hintStyle: const TextStyle(color: Colors.black45),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),

  colorScheme: const ColorScheme(
    brightness: Brightness.light,
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
