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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: const Color(0xFF9359FF),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      shadowColor: Colors.transparent,
    ).copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF9359FF),
      textStyle: const TextStyle(decoration: TextDecoration.underline),
    ),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF9359FF),
    primaryContainer: Color(0xFFEDE0FF),
    secondary: Color(0xFF78909C),
    secondaryContainer: Color(0xFFCFD8DC),
    surface: Colors.white,
    background: Colors.white,
    error: Color(0xFFD32F2F),
    onPrimary: Colors.white,
    onSecondary: Colors.black87,
    onSurface: Color(0xFF414141),
    onError: Colors.white,
  ),
);
