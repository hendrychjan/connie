import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:hive/hive.dart';

part 'income.g.dart';

// Generate script: dart run build_runner build

@HiveType(typeId: 2)
class Income extends FinancialRecord {
  Income({
    required super.id,
    required super.title,
    required super.amount,
    required super.date,
    super.comment,
  });

  static Future<Income?> getById(String id) async {
    return await AppController.to.hiveService.financialRecordBox.get(id)
        as Income?;
  }
}
