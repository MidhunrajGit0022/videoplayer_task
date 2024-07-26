import 'package:flutter/material.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1E1E2A),
      secondary: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  final darktheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF1E1E2A),
  );
}
