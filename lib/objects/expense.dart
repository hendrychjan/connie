import 'package:connie/objects/financial_record.dart';
import 'package:hive/hive.dart';

part 'expense.g.dart';

// Generate script: dart run build_runner build

@HiveType(typeId: 1)
class Expense extends FinancialRecord {
  Expense(
    String id,
    DateTime date,
    double amount,
    String comment,
  ) : super(id, date, amount, comment);
}
