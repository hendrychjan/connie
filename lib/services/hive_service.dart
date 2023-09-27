import 'package:bson/bson.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/category_on_record.dart';
import 'package:connie/objects/expense.dart';
import 'package:connie/objects/income.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  late Box<Category> categoryBox;
  late LazyBox<CategoryOnRecord> categoryOnRecordBox;
  late LazyBox<FinancialRecord> financialRecordBox;
  late LazyBox<Expense> expenseBox;
  late LazyBox<Income> incomeBox;

  Future<void> init() async {
    categoryBox = await Hive.openBox<Category>('category');
    categoryOnRecordBox =
        await Hive.openLazyBox<CategoryOnRecord>('categoryOnRecord');
    financialRecordBox =
        await Hive.openLazyBox<FinancialRecord>('financialRecord');
    expenseBox = await Hive.openLazyBox<Expense>('expense');
    incomeBox = await Hive.openLazyBox<Income>('income');
  }

  static String generateId() {
    String id = ObjectId().toHexString();
    return id;
  }
}
