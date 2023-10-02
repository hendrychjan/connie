import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalTheme {
  static get defaultTheme => _buildTheme();
  static get defaultDarkTheme => _buildDarkTheme();

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

  static void changeThemeMode(String theme) {
    if (theme == "light") {
      Get.changeThemeMode(ThemeMode.light);
    } else if (theme == "dart") {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  static ThemeData _buildTheme() {
    return ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
      useMaterial3: true,
    );
  }
}
