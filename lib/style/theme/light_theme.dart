import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  textTheme: Typography().black.apply(fontFamily: "DM Sans"),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
    elevation: 0,
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xffadadad), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xffe2e2e2), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xffadadad), width: 1),
    ),
  ),

  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF9359FF),
    onPrimaryFixedVariant: Color(0xfffff1ff),
    onPrimary: Colors.white,
    secondary: Color(0xFF414141),
    onSecondary: Color(0xff2c2c2c),
    tertiary: Color(0xff00005f),
    outline: Color(0xffe4e4e4),
    onInverseSurface: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xff333333),
    onSurfaceVariant: Color.fromARGB(255, 139, 139, 139),
    error: Color(0xfffd7a7a),
    onError: Colors.white,
  ),
);
