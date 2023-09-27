import 'package:connie/getx/app_controller.dart';
import 'package:connie/pages/splash_screen.dart';
import 'package:connie/ui/local_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(AppController());

  runApp(
    GetMaterialApp(
      title: 'Connie',
      theme: LocalTheme.defaultTheme,
      home: const SplashScreen(),
    ),
  );
}
