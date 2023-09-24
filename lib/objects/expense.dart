import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:hive/hive.dart';

part 'expense.g.dart';

// Generate script: dart run build_runner build

@HiveType(typeId: 1)
class Expense extends FinancialRecord {
  Expense(
    String id,
    String title,
    double amount,
    DateTime date,
    String? comment,
  ) : super(id, title, amount, date, comment);

  @override
  Future<void> save() async {
    await AppController.to.hiveService.expenseBox!.put(id, this);
  }

  static Future<Expense?> getById(String id) async {
    return await AppController.to.hiveService.expenseBox!.get(id);
  }
}
