import 'package:connie/getx/app_controller.dart';
import 'package:connie/ui/local_theme.dart';
import 'package:connie/widgets/common/form/form_field_dropdown.dart';
import 'package:connie/widgets/common/loading_text_button.dart';
import 'package:connie/widgets/common/privacy_notice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: "App info"),
                  _AppStatisticsSection(),
                  _SectionHeader(title: "Appearance"),
                  _AppearanceSection(),
                  _SectionHeader(title: "Data"),
                  _DataSection(),
                ],
              ),
            ),
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

class _DataSection extends StatefulWidget {
  const _DataSection();

  @override
  State<_DataSection> createState() => _DataSectionState();
}

class _DataSectionState extends State<_DataSection> {
  void _openPrivacyNoticeDialog() async {
    Get.dialog(const PrivacyNoticeDialog());
  }

  Future<void> _handleBackupData() async {
    await AppController.to.hiveService.backupApplicationData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoadingTextButton(
          onPressed: _handleBackupData,
          icon: const Icon(Icons.cloud_upload),
          label: "Create backup",
        ),
        TextButton.icon(
          onPressed: _openPrivacyNoticeDialog,
          icon: const Icon(Icons.info),
          label: const Text("Privacy notice"),
        ),
      ],
    );
  }
}

class _AppStatisticsSection extends StatelessWidget {
  const _AppStatisticsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    "Categories: ${AppController.to.hiveService.categoryBox.length}",
                  ),
                  Text(
                    "Categories on Records: ${AppController.to.hiveService.categoryOnRecordBox.length}",
                  ),
                  Text(
                    "Financial records: ${AppController.to.hiveService.financialRecordBox.length}",
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AppearanceSection extends StatefulWidget {
  const _AppearanceSection();

  @override
  State<_AppearanceSection> createState() => __AppearanceSectionState();
}

class __AppearanceSectionState extends State<_AppearanceSection> {
  final _themeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldDropdown(
          hint: "Theme",
          icon: const Icon(Icons.color_lens),
          initialSelection:
              AppController.to.hiveService.preferencesBox.get("theme"),
          controller: _themeController,
          items: const [
            DropdownMenuEntry(value: "system", label: "System"),
            DropdownMenuEntry(value: "dark", label: "Dark"),
            DropdownMenuEntry(value: "light", label: "Light"),
          ],
          onSelected: (val) {
            AppController.to.hiveService.preferencesBox
                .put("theme", _themeController.text);
            LocalTheme.changeThemeMode(_themeController.text);
          },
        )
      ],
    );
  }
}

class _SectionHeader extends StatefulWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  State<_SectionHeader> createState() => __SectionHeaderState();
}

class __SectionHeaderState extends State<_SectionHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Divider(),
        ),
      ],
    );
  }
}
