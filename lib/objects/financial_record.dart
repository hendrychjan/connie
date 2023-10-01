import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/category_on_record.dart';
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

  Future<void> save(List<Category> categories) async {
    if (!AppController.to.hiveService.financialRecordBox.containsKey(id)) {
      // Creating the object
      // ...create relationships
      await CategoryOnRecord.createAllByRecord(this, categories);

      // ...update the global 'currentBalance'
      AppController.to.currentBalance.value += amount;
    } else {
      // Updating the object
      // ...update relationships
      await CategoryOnRecord.deleteAllByRecord(this);
      await CategoryOnRecord.createAllByRecord(this, categories);

      // ...compute the netto amount, and update the global 'currentBalance'
      FinancialRecord previousRecord =
          await AppController.to.hiveService.financialRecordBox.get(id);
      AppController.to.currentBalance.value -= previousRecord.amount - amount;
    }
    AppController.to.hiveService.preferencesBox
        .put("currentBalance", AppController.to.currentBalance.value);

    // Save the object to DB
    await AppController.to.hiveService.financialRecordBox.put(id, this);

    // If it belongs to the current period, then run the period update hook
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
    // Delete all relationships
    await CategoryOnRecord.deleteAllByRecord(this);

    // Update the global 'currentBalance'
    AppController.to.currentBalance.value -= amount;
    AppController.to.hiveService.preferencesBox
        .put("currentBalance", AppController.to.currentBalance.value);

    // Delete the object from DB
    await AppController.to.hiveService.financialRecordBox.delete(id);

    // If it belongs to the current period, then run the period update hook
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
