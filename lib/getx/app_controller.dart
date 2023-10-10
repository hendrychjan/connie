import 'package:connie/objects/expense.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/services/backup_service.dart';
import 'package:connie/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  String appVersion = "";
  late Widget firstPage;

  RxBool showDecimals = false.obs;
  RxString currency = "Kč".obs;

  RxDouble currentBalance = 0.0.obs;
  RxDouble periodExpenses = 0.0.obs;
  RxList<FinancialRecord> weeklyRecords =
      RxList<FinancialRecord>.empty(growable: true);

  HiveService hiveService = HiveService();
  BackupService backupService = BackupService();
  Rxn<NumberFormat> currencyFormat = Rxn<NumberFormat>();

  /// This function should be run each time the 'weeklyRecords' field gets
  /// updated
  void weeklyRecordsHook() {
    // Sort newest -> oldest
    weeklyRecords.sort((a, b) => b.date.compareTo(a.date));

    // Update the periodExpenses field accordingly
    periodExpenses.value = 0.0;
    for (FinancialRecord r in weeklyRecords) {
      if (r is Expense) {
        periodExpenses.value += r.amount;
      }
    }
  }

  static Future<String> getDefaultCurrencySymbol() async {
    String locale = await findSystemLocale();
    return NumberFormat.currency(locale: locale).currencySymbol;
  }
}
