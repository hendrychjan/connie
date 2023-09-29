import 'package:bson/bson.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/category_on_record.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  late Box<Category> categoryBox;
  late LazyBox<CategoryOnRecord> categoryOnRecordBox;
  late LazyBox financialRecordBox;

  Future<void> init() async {
    categoryBox = await Hive.openBox<Category>('category');

    categoryOnRecordBox =
        await Hive.openLazyBox<CategoryOnRecord>('categoryOnRecord');

    // Although only classes derived from FinancialRecord should be stored here,
    // the box is not defined with a type, because Hive does not support
    // subclasses in a typed box
    financialRecordBox = await Hive.openLazyBox('financialRecord');
  }

  static String generateId() {
    String id = ObjectId().toHexString();
    return id;
  }

  static bool isDateInWeek(
    DateTime date, {
    int endOfWeekDay = DateTime.sunday,
  }) {
    DateTime now = DateTime.now();

    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: endOfWeekDay - 1));

    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }
}
