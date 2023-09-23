import 'package:connie/objects/expense.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/objects/income.dart';
import 'package:hive_flutter/adapters.dart';

class InitService {
  static Future<void> initApp() async {
    await _initHive();
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(FinancialRecordAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(IncomeAdapter());
  }
}
