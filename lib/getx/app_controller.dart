import 'package:connie/objects/expense.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/objects/income.dart';
import 'package:connie/services/hive_service.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  RxList<FinancialRecord> weeklyRecords =
      RxList<FinancialRecord>.empty(growable: true);

  HiveService hiveService = HiveService();

  void weeklyRecordsHook() {
    // Sort newest -> oldest
    weeklyRecords.sort((a, b) => b.date.compareTo(a.date));

    for (var record in weeklyRecords) {
      if (record is Expense)
        print(record);
      else if (record is Income)
        print(record);
      else
        print(record);
    }
  }
}
