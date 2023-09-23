import 'package:hive/hive.dart';

part 'financial_record.g.dart';

// Generate script: dart run build_runner build

@HiveType(typeId: 0)
class FinancialRecord {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String comment;

  FinancialRecord(
    this.id,
    this.date,
    this.amount,
    this.comment,
  );
}
