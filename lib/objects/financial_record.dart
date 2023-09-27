import 'package:connie/getx/app_controller.dart';
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
  }

  static Future<FinancialRecord?> getById(String id) async {
    return await AppController.to.hiveService.financialRecordBox.get(id);
  }
}
