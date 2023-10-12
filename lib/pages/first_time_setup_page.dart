import 'package:connie/forms/first_time_setup_form.dart';
import 'package:connie/getx/app_controller.dart';
import 'package:connie/pages/home_page.dart';
import 'package:connie/services/backup_service.dart';
import 'package:connie/services/init_service.dart';
import 'package:connie/widgets/common/error_dialog.dart';
import 'package:connie/widgets/common/loading_text_button.dart';
import 'package:connie/widgets/common/privacy_notice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class FirstTimeSetupPage extends StatefulWidget {
  const FirstTimeSetupPage({super.key});

  @override
  State<FirstTimeSetupPage> createState() => _FirstTimeSetupPageState();
}

class _FirstTimeSetupPageState extends State<FirstTimeSetupPage> {
  Future<void> _handleSubmit(Map<String, dynamic> payload) async {
    Box preferences = AppController.to.hiveService.preferencesBox;

    // Current balance
    AppController.to.currentBalance.value = payload["currentBalance"];
    await preferences.put("currentBalance", payload["currentBalance"]);

    // Show decimals
    AppController.to.showDecimals.value = payload["showDecimals"];
    await preferences.put("showDecimals", payload["showDecimals"]);

    // Currency
    AppController.to.currency.value = payload["currency"];
    await preferences.put("currency", payload["currency"]);

    preferences.put("everOpened", true);

    await InitService.initAppAppearance();

    Get.offAll(() => const HomePage());
  }

  void _openPrivacyNotice() {
    Get.dialog(const PrivacyNoticeDialog());
  }

  Future<void> _startFromBackup() async {
    try {
      await AppController.to.backupService.restoreApplicationData(
        MergeStrategy.replaceAll,
      );
      Get.offAll(() => const HomePage());
    } catch (e) {
      Get.dialog(ErrorDialog(message: e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick setup"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Before we begin...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            FirstTimeSetupForm(onSubmit: _handleSubmit),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: LoadingTextButton(
                onPressed: _startFromBackup,
                icon: const Icon(Icons.cloud_download),
                label: "Start from backup",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextButton.icon(
                onPressed: _openPrivacyNotice,
                icon: const Icon(Icons.info),
                label: const Text("How do we handle your data?"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
