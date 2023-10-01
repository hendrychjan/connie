import 'package:connie/getx/app_controller.dart';
import 'package:connie/pages/first_time_setup_page.dart';
import 'package:connie/pages/home_page.dart';
import 'package:connie/services/init_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () async {
      await InitService.initApp();

      if (AppController.to.firstTimeOpened) {
        Get.offAll(() => const FirstTimeSetupPage());
      } else {
        Get.offAll(() => const HomePage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
