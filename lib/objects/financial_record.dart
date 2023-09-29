import 'package:connie/getx/app_controller.dart';
import 'package:connie/services/hive_service.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

part 'financial_record.g.dart';

// Generate script: dart run build_runner build

@HiveType(typeId: 0)
class FinancialRecord {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String? comment;

  FinancialRecord({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.comment,
  });

  Future<void> save() async {
    await AppController.to.hiveService.financialRecordBox.put(id, this);

    if (HiveService.isDateInWeek(date)) {
      int index;
      if ((index = AppController.to.weeklyRecords
              .indexWhere((element) => element.id == id)) !=
          -1) {
        // Already in the list - remove, because update will be added
        AppController.to.weeklyRecords.removeAt(index);
      }
      AppController.to.weeklyRecords.add(this);
      AppController.to.weeklyRecordsHook();
    }
  }

  Future<void> delete() async {
    await AppController.to.hiveService.financialRecordBox.put(id, this);

    if (HiveService.isDateInWeek(date)) {
      AppController.to.weeklyRecords.removeWhere((element) => element.id == id);
      AppController.to.weeklyRecordsHook();
    }
  }

  static Future<FinancialRecord?> getById(String id) async {
    return await AppController.to.hiveService.financialRecordBox.get(id);
  }

  static Future<List<FinancialRecord>> getThisWeek() async {
    List<FinancialRecord> weekly = List<FinancialRecord>.empty(growable: true);

    for (var key in AppController.to.hiveService.financialRecordBox.keys) {
      FinancialRecord record =
          await AppController.to.hiveService.financialRecordBox.get(key);
      weekly.addIf(HiveService.isDateInWeek(record.date), record);
    }

    return weekly;
  }
}
