import 'package:flutter/material.dart';

class LocalTheme {
  static get defaultTheme => _buildTheme();

  static ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      ),
      useMaterial3: true,
    );
  }
}
