import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:hive/hive.dart';

part 'expense.g.dart';

// Generate script: dart run build_runner build

@HiveType(typeId: 1)
class Expense extends FinancialRecord {
  Expense({
    required super.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.comment,
  });

  static Future<Expense?> getById(String id) async {
    return await AppController.to.hiveService.financialRecordBox.get(id)
        as Expense?;
  }
}
