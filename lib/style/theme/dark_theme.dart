import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: Typography().white.apply(fontFamily: "DM Sans"),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Color(0xFFE1E1E1),
    elevation: 0,
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF404040), width: 1),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF2C2C2C), width: 1),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF606060), width: 1),
    ),
  ),

  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF7944DB),
    onPrimary: Color.fromARGB(255, 236, 236, 236),
    secondary: Color(0xFFB8B8B8),
    onSecondary: Color(0xFFE1E1E1),
    tertiary: Color(0xFFd4c1ff),
    outline: Color(0xFF2C2C2C),
    onInverseSurface: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE1E1E1),
    onSurfaceVariant: Color(0xFF9E9E9E),
    error: Color(0xFFCF6679),
    onError: Color(0xFF1E1E1E),
  ),
);
