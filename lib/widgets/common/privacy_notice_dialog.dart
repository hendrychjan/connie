import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PrivacyNoticeDialog extends StatelessWidget {
  const PrivacyNoticeDialog({super.key});

  void _openGithubRepository() async {
    await launchUrlString("https://github.com/hendrychjan/connie");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Privacy notice"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              "Connie takes privacy seriously.",
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "Internal storage",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
                "All of your data, from app theme preferences, to your financial records, is saved internally within your device. We do not, and even cannot access, store, or share any of your information."),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "Open Source Transparency",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
                "We believe in transparency. Connie is an open-source app, and you can explore the codebase on our GitHub repository. Feel free to inspect how we protect your data and uphold your privacy."),
          ),
          TextButton(
            onPressed: _openGithubRepository,
            child: const Text("Open on GitHub"),
          )
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Ok")),
      ],
    );
  }
}
