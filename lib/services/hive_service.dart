import 'package:bson/bson.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/category_on_record.dart';
import 'package:connie/services/backup_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  late Box preferencesBox;
  late Box<Category> categoryBox;
  late LazyBox<CategoryOnRecord> categoryOnRecordBox;
  late LazyBox financialRecordBox;

  Future<void> init() async {
    preferencesBox = await Hive.openBox('preferences');

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
    DateTime today = DateTime(now.year, now.month, now.day);

    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime endOfWeek = startOfWeek
        .add(Duration(days: endOfWeekDay))
        .subtract(const Duration(milliseconds: 1));

    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  static Future<void> copyBox<T extends BoxBase>({
    Iterable<dynamic>? keys,
    Box? sourceBox,
    LazyBox? sourceLazyBox,
    required T destination,
    required MergeStrategy strategy,
  }) async {
    // Check if arguments were provided
    if (sourceBox == null && sourceLazyBox == null) {
      throw ArgumentError(
        "Either sourceBox, or sourceLazyBox must be provided.",
      );
    }

    // If an exact list of keys was not provided, set the default - all keys
    // from the source
    if (keys == null) {
      if (sourceBox != null) {
        keys = sourceBox.keys;
      } else {
        keys = sourceLazyBox!.keys;
      }
    }

    // A procedure that will copy the value from one box to another
    runItemCopyProcedure(var key) async {
      if (sourceBox != null) {
        // copy into simple box
        await destination.put(key, sourceBox.get(key));
      } else {
        // copy into lazy box
        await destination.put(key, await sourceLazyBox!.get(key));
      }
    }

    // Copy the data between boxes
    if (strategy == MergeStrategy.replaceAll) {
      await destination.clear();
    }

    for (var key in keys) {
      if (strategy == MergeStrategy.append && destination.containsKey(key)) {
        continue;
      }

      await runItemCopyProcedure(key);
    }
  }
}
