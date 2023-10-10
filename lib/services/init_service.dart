import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/category_on_record.dart';
import 'package:connie/objects/expense.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/objects/income.dart';
import 'package:connie/pages/first_time_setup_page.dart';
import 'package:connie/pages/home_page.dart';
import 'package:connie/ui/local_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InitService {
  static Future<void> initApp() async {
    _registerGetxSingletons();
    await _initIntl();
    await _initHive();
    await _initControllerServices();
    await initControllerFields();
    await _initAppInfo();
    await initAppAppearance();
  }

  static void _registerGetxSingletons() {
    Get.put(AppController());
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(CategoryOnRecordAdapter());
    Hive.registerAdapter(FinancialRecordAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(IncomeAdapter());
  }

  static Future<void> _initControllerServices() async {
    await AppController.to.hiveService.init();
  }

  static Future<void> initControllerFields() async {
    Box preferences = AppController.to.hiveService.preferencesBox;

    // Check if this is the first time the app has been opened
    if (preferences.containsKey("everOpened")) {
      AppController.to.firstPage = const HomePage();
    } else {
      AppController.to.firstPage = const FirstTimeSetupPage();
    }

    // Load the currentBalance
    AppController.to.currentBalance.value =
        (preferences.get("currentBalance")) ?? 0.0;

    // Load the formatting settings
    AppController.to.showDecimals.value =
        preferences.get("showDecimals") ?? false;
    AppController.to.currency.value = preferences.get("currency") ??
        (await AppController.getDefaultCurrencySymbol());

    // Load the period (weekly) records
    AppController.to.weeklyRecords.clear();
    AppController.to.weeklyRecords.addAll(await FinancialRecord.getThisWeek());
    AppController.to.weeklyRecordsHook();
  }

  static Future<void> _initAppInfo() async {
    PackageInfo pi = await PackageInfo.fromPlatform();
    AppController.to.appVersion = pi.version;
  }

  static Future<void> _initIntl() async {
    String locale = await findSystemLocale();
    await initializeDateFormatting(locale);
  }

  static Future<void> initAppAppearance() async {
    // Set the previously selected theme
    if (!AppController.to.hiveService.preferencesBox.containsKey("theme")) {
      // If it has never been previously set, initialize it with the default
      // -> system mode
      AppController.to.hiveService.preferencesBox.put("theme", "system");
      Get.changeThemeMode(ThemeMode.system);
      return;
    }

    String theme =
        AppController.to.hiveService.preferencesBox.get("theme") ?? "";
    LocalTheme.changeThemeMode(theme);

    // Build the currency format
    String locale = await findSystemLocale();
    AppController.to.currencyFormat.value = NumberFormat.currency(
      locale: locale,
      decimalDigits: (AppController.to.showDecimals.value) ? 2 : 0,
      symbol: AppController.to.currency.value,
    );
  }
}
