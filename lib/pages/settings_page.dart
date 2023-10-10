import 'package:connie/getx/app_controller.dart';
import 'package:connie/pages/home_page.dart';
import 'package:connie/services/backup_service.dart';
import 'package:connie/services/init_service.dart';
import 'package:connie/ui/local_theme.dart';
import 'package:connie/widgets/common/form/form_field_checkbox.dart';
import 'package:connie/widgets/common/form/form_field_dropdown.dart';
import 'package:connie/widgets/common/form/form_field_text.dart';
import 'package:connie/widgets/common/info_label_widget.dart';
import 'package:connie/widgets/common/loading_elevated_button.dart';
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
    await AppController.to.backupService.backupApplicationData();
  }

  Future<void> _handleStartBackupRestore(MergeStrategy strategy) async {
    Get.back();
    Get.dialog(AlertDialog(
      title: const Text("Restore backup"),
      content: const Text(
        "This action is going to alter the application data. Once you click \"Start\", it cannot be taken back. If you are not 100% sure of what are you doing, it is recommended to reach out for help, or at least backup your current data.",
      ),
      actions: [
        LoadingTextButton(
          onPressed: () async {
            await AppController.to.backupService
                .restoreApplicationData(strategy);
            Get.offAll(() => const HomePage());
          },
          icon: const Icon(Icons.warning),
          label: "Start",
        ),
        ElevatedButton(
          onPressed: Get.back,
          child: const Text("Cancel"),
        ),
      ],
    ));
  }

  Future<void> _handleOpenRestoreDataDialog() async {
    Get.dialog(AlertDialog(
      title: const Text("Restore backup"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          LoadingElevatedButton(
            onPressed: () async =>
                await _handleStartBackupRestore(MergeStrategy.replaceAll),
            label: "Replace all",
            icon: const Icon(Icons.published_with_changes),
          ),
          const InfoLabelWidget(
            message:
                "Completely replace the current app state with the backup data.",
          ),
          const Divider(),
          // NOTE: DO NOT DELETE THESE!! The remaining two merge strategies are
          // almost ready, they just need a few tweaks, and are expected to be
          // finished in the near future
          // LoadingElevatedButton(
          //   onPressed: () async =>
          //       await _handleStartBackupRestore(MergeStrategy.forward),
          //   label: "Merge - forward",
          //   icon: const Icon(Icons.redo),
          // ),
          // const InfoLabelWidget(
          //   message:
          //       "Keep the existing app data with the backup, but treat the backup data as primary/newest.",
          // ),
          // const Divider(),
          // LoadingElevatedButton(
          //   onPressed: () async => await _handleStartBackupRestore(
          //     MergeStrategy.append,
          //   ),
          //   label: "Merge - append",
          //   icon: const Icon(Icons.add),
          // ),
          // const InfoLabelWidget(
          //   message:
          //       "Keep the existing app data with the backup, but treat the current application data as primary/newest.",
          // ),
          // const Divider(),
        ],
      ),
      actions: [TextButton(onPressed: Get.back, child: const Text("Cancel"))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoadingTextButton(
          onPressed: _handleBackupData,
          icon: const Icon(Icons.cloud_upload),
          label: "Create backup",
        ),
        LoadingTextButton(
          onPressed: _handleOpenRestoreDataDialog,
          icon: const Icon(Icons.cloud_download),
          label: "Restore backup",
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
  final _showDecimalsController = TextEditingController();
  final _currencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showDecimalsController.text =
        AppController.to.showDecimals.value.toString();
    _currencyController.text = AppController.to.currency.value;
  }

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
        ),
        FormFieldCheckbox(
          controller: _showDecimalsController,
          label: "Show decimals",
          onChanged: (value) async {
            AppController.to.showDecimals.value = bool.parse(value.toString());
            AppController.to.hiveService.preferencesBox
                .put("showDecimals", value);
            await InitService.initAppAppearance();
          },
        ),
        FormFieldText(
          hint: "Currency",
          controller: _currencyController,
          onSubmit: (String value) async {
            AppController.to.currency.value = value;
            AppController.to.hiveService.preferencesBox.put("currency", value);
            await InitService.initAppAppearance();
          },
        ),
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
