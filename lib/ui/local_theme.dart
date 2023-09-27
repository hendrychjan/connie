import 'package:flutter/material.dart';

class LocalTheme {
  static get defaultTheme => _buildTheme();

  static String colorToHexString(Color color) {
    String res = "#";
    res += color.red.toRadixString(16).padLeft(2, '0');
    res += color.green.toRadixString(16).padLeft(2, '0');
    res += color.blue.toRadixString(16).padLeft(2, '0');

    return res;
  }

  static Color hexStringToColor(String color) {
    if (color.isEmpty) return Colors.white;

    String radixString = "FF${color.substring(1)}";
    int? intColor = int.tryParse(radixString, radix: 16);
    return Color(intColor ?? 0xFFFFFFFF);
  }

  static ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      ),
      useMaterial3: true,
    );
  }
}
