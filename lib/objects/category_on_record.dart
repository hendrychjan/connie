import 'package:connie/getx/app_controller.dart';
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

  CategoryOnRecord(
    this.id,
    this.recordId,
    this.categoryId,
  );

  Future<void> save() async {
    await AppController.to.hiveService.categoryOnRecordBox!.put(id, this);
  }
}
