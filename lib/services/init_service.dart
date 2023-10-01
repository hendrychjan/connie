import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/category_on_record.dart';
import 'package:connie/objects/expense.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/objects/income.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InitService {
  static Future<void> initApp() async {
    await _initHive();
    await _initControllerServices();
    await _initControllerFields();
    await _initAppInfo();
  }

  static Future<void> _initAppInfo() async {
    PackageInfo pi = await PackageInfo.fromPlatform();
    AppController.to.appVersion = pi.version;
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

  static Future<void> _initControllerFields() async {
    // Check if this is the first time the app has been opened
    AppController.to.firstTimeOpened =
        !AppController.to.hiveService.preferencesBox.containsKey("everOpened");

    // Load the currentBalance
    AppController.to.currentBalance.value = (await AppController
            .to.hiveService.preferencesBox
            .get("currentBalance")) ??
        0.0;

    // Load the period (weekly) records
    AppController.to.weeklyRecords.addAll(await FinancialRecord.getThisWeek());
    AppController.to.weeklyRecordsHook();
  }
}
