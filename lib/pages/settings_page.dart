import 'package:connie/getx/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Text(
                "App statistics",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            const Text(
              "No. of objects:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            AnimatedBuilder(
              animation: Listenable.merge([
                AppController.to.hiveService.categoryBox.listenable(),
                AppController.to.hiveService.categoryOnRecordBox.listenable(),
                AppController.to.hiveService.financialRecordBox.listenable(),
              ]),
              builder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Categories: ${AppController.to.hiveService.categoryBox.length}"),
                    Text(
                        "Categories on Records: ${AppController.to.hiveService.categoryOnRecordBox.length}"),
                    Text(
                        "Financial records: ${AppController.to.hiveService.financialRecordBox.length}"),
                  ],
                );
              },
            ),
            Expanded(child: Container()),
            Center(
              child: Text(
                "v${AppController.to.appVersion}\nby Jan Hendrych",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
