import 'package:connie/forms/first_time_setup_form.dart';
import 'package:connie/getx/app_controller.dart';
import 'package:connie/pages/home_page.dart';
import 'package:connie/widgets/common/privacy_notice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirstTimeSetupPage extends StatefulWidget {
  const FirstTimeSetupPage({super.key});

  @override
  State<FirstTimeSetupPage> createState() => _FirstTimeSetupPageState();
}

class _FirstTimeSetupPageState extends State<FirstTimeSetupPage> {
  Future<void> _handleSubmit(Map<String, dynamic> payload) async {
    // Current balance
    AppController.to.currentBalance.value = payload["currentBalance"];
    AppController.to.hiveService.preferencesBox
        .put("currentBalance", payload["currentBalance"]);

    AppController.to.hiveService.preferencesBox.put("everOpened", true);

    Get.offAll(() => const HomePage());
  }

  void _openPrivacyNotice() {
    Get.dialog(const PrivacyNoticeDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick setup"),
      ),
      body: Column(
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
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextButton(
              onPressed: _openPrivacyNotice,
              child: const Text("How do we handle your data?"),
            ),
          ),
        ],
      ),
    );
  }
}
