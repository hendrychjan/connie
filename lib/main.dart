import 'package:connie/getx/app_controller.dart';
import 'package:connie/services/init_service.dart';
import 'package:connie/ui/local_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  await InitService.initApp();

  runApp(
    GetMaterialApp(
      title: 'Connie',
      home: AppController.to.firstPage,
      theme: LocalTheme.defaultTheme,
      darkTheme: LocalTheme.defaultDarkTheme,
    ),
  );
}
