import 'dart:convert';
import 'dart:io';
import 'package:bson/bson.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/category_on_record.dart';
import 'package:connie/objects/expense.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/objects/income.dart';
import 'package:connie/services/backup_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<void> backupApplicationData() async {
    Map backupMap = await _generateBackupData();
    String backupFilePath = await _writeBackupIntoFile(backupMap);
    await _shareBackup(backupFilePath);
    // The file must not be deleted, because the share can take some time to
    // complete (e.g. on google disk, when it is waiting for wifi connection)
    // and so the file has to be available later. The file will eventually
    // be deleted after some time (days), or when manual storage cleanup is
    // invoked by the user.
  }

  Future<void> _shareBackup(String backupFilePath) async {
    await Share.shareXFiles([XFile(backupFilePath)]);
  }

  Future<String> _writeBackupIntoFile(Map backup) async {
    String date = DateFormat("dd-M-yyyy").format(DateTime.now());
    String fileName = "connie_backup_${date}_${HiveService.generateId()}";
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$fileName.json");
    await file.writeAsString(jsonEncode(backup), flush: true);
    return file.path;
  }

  Future<Map<String, dynamic>> _generateBackupData() async {
    Map<String, dynamic> backup = {};

    // Get the preferences
    backup["preferences"] = {
      "theme": preferencesBox.get("theme"),
      "currentBalance": preferencesBox.get("currentBalance"),
    };

    // Get the categories
    backup["categories"] = [];
    for (Category category in categoryBox.values) {
      (backup["categories"] as List).add(category.toMap());
    }

    // Get the Financial Records
    backup["financialRecords"] = {
      "records": [],
      "expenses": [],
      "incomes": [],
    };
    for (var key in financialRecordBox.keys) {
      FinancialRecord? record = await financialRecordBox.get(key);
      if (record is Expense) {
        (backup["financialRecords"]["expenses"] as List).add(record.toMap());
      } else if (record is Income) {
        (backup["financialRecords"]["incomes"] as List).add(record.toMap());
      } else if (record != null) {
        (backup["financialRecords"]["records"] as List).add(record.toMap());
      }
    }

    // Get the relationships between categories and financial records
    backup["categoriesOnRecords"] = [];
    for (var key in categoryOnRecordBox.keys) {
      CategoryOnRecord? cor = await categoryOnRecordBox.get(key);
      if (cor != null) {
        (backup["categoriesOnRecords"] as List).add(cor.toMap());
      }
    }

    return backup;
  }
}
