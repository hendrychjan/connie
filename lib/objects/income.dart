import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:hive/hive.dart';

part 'income.g.dart';

@HiveType(typeId: 2)
class Income extends FinancialRecord {
  Income(
    String id,
    String title,
    double amount,
    DateTime date,
    String? comment,
  ) : super(id, title, amount, date, comment);

  @override
  Future<void> save() async {
    await AppController.to.hiveService.incomeBox!.put(id, this);
  }

  static Future<Income?> getById(String id) async {
    return await AppController.to.hiveService.incomeBox!.get(id);
  }
}
