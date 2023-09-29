import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/category_on_record.dart';
import 'package:connie/objects/expense.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/objects/income.dart';
import 'package:hive_flutter/adapters.dart';

class InitService {
  static Future<void> initApp() async {
    await _initHive();
    await _initControllerServices();
    await _initControllerFields();
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
    // Weekly records
    AppController.to.weeklyRecords.addAll(await FinancialRecord.getThisWeek());
    AppController.to.weeklyRecordsHook();
  }
}
