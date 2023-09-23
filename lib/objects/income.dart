import 'package:connie/objects/financial_record.dart';
import 'package:hive/hive.dart';

part 'income.g.dart';

@HiveType(typeId: 2)
class Income extends FinancialRecord {
  Income(
    String id,
    DateTime date,
    double amount,
    String comment,
  ) : super(id, date, amount, comment);
}
