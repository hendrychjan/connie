import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/services/hive_service.dart';
import 'package:hive/hive.dart';

part 'category_on_record.g.dart';

// Generate script: dart run build_runner build

@HiveType(typeId: 4)
class CategoryOnRecord {
  @HiveField(0)
  String id;

  @HiveField(1)
  String recordId;

  @HiveField(2)
  String categoryId;

  CategoryOnRecord({
    required this.id,
    required this.recordId,
    required this.categoryId,
  });

  factory CategoryOnRecord.fromMap(Map map) {
    return CategoryOnRecord(
      id: map["id"],
      recordId: map["recordId"],
      categoryId: map["categoryId"],
    );
  }

  Map toMap() {
    return {
      "id": id,
      "recordId": recordId,
      "categoryId": categoryId,
    };
  }

  Future<void> save() async {
    await AppController.to.hiveService.categoryOnRecordBox.put(id, this);
  }

  Future<void> delete() async {
    await AppController.to.hiveService.categoryOnRecordBox.delete(id);
  }

  static Future<void> createAllByRecord(
      FinancialRecord record, List<Category> categories) async {
    for (Category category in categories) {
      await CategoryOnRecord(
        id: HiveService.generateId(),
        categoryId: category.id,
        recordId: record.id,
      ).save();
    }
  }

  static Future<void> deleteAllByRecord(FinancialRecord record) async {
    for (var key in AppController.to.hiveService.categoryOnRecordBox.keys) {
      CategoryOnRecord? cor =
          await AppController.to.hiveService.categoryOnRecordBox.get(key);
      if (cor != null && cor.recordId == record.id) {
        await AppController.to.hiveService.categoryOnRecordBox.delete(key);
      }
    }
  }
}
