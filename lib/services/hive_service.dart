import 'dart:convert';
import 'dart:io';
import 'package:bson/bson.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/category_on_record.dart';
import 'package:connie/objects/expense.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/objects/income.dart';
import 'package:connie/services/init_service.dart';
import 'package:connie/ui/local_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
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

  Future<void> restoreApplicationdata(BackupRestoreStrategy strategy) async {
    Map backup = await _loadBackupFromFile();
    _validateBackupMap(backup);
    _decodeBackupObjects(backup, strategy);
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

  Future<void> _decodeBackupObjects(
      Map backup, BackupRestoreStrategy strategy) async {
    // Create hive boxes. Into those, objects from the backup json will be
    // loaded temporarily
    Box tempPreferencesBox = await Hive.openBox("tmp_preferences");
    LazyBox<Category> tempCategoriesBox =
        await Hive.openLazyBox("tmp_category");
    LazyBox tempFinancialRecordsBox =
        await Hive.openLazyBox("tmp_financialRecord");
    LazyBox tempCategoriesOnRecordsBox =
        await Hive.openLazyBox("tmp_categoryOnRecord");

    // Clear the boxes, in case there were some left over from a previous
    // unsuccessfull backup restore
    await tempPreferencesBox.clear();
    await tempCategoriesBox.clear();
    await tempFinancialRecordsBox.clear();
    await tempCategoriesOnRecordsBox.clear();

    // Decode all objects from the backup json into those temporary hive boxes
    try {
      // Decode preferences
      Map preferences = backup["preferences"] as Map;
      String theme = preferences["theme"];
      double currentBalance =
          double.parse(preferences["currentBalance"].toString());

      await tempPreferencesBox.put("theme", theme);
      await tempPreferencesBox.put("currentBalance", currentBalance);

      // Decode categories
      List categories = backup["categories"] as List;
      for (Map categoryMap in categories) {
        Category c = Category.fromMap(categoryMap);
        await tempCategoriesBox.put(c.id, c);
      }

      // Decode expenses
      List expenses = backup["financialRecords"]["expenses"] as List;
      for (Map expenseMap in expenses) {
        Expense e = Expense.fromMap(expenseMap);
        await tempFinancialRecordsBox.put(e.id, e);
      }

      // Decode incomes
      List incomes = backup["financialRecords"]["incomes"] as List;
      for (Map incomeMap in incomes) {
        Income i = Income.fromMap(incomeMap);
        await tempFinancialRecordsBox.put(i.id, i);
      }

      // Decode categories on financial records
      List categoriesOnRecords = backup["categoriesOnRecords"] as List;
      for (Map categoryOnRecordMap in categoriesOnRecords) {
        CategoryOnRecord cor = CategoryOnRecord.fromMap(categoryOnRecordMap);
        if (!tempCategoriesBox.containsKey(cor.categoryId)) {
          throw "Missing category for CategoryOnRecord relationship.";
        }
        if (!tempFinancialRecordsBox.containsKey(cor.recordId)) {
          throw "Missing record for CategoryOnRecord relationship.";
        }
        await tempCategoriesOnRecordsBox.put(cor.id, cor);
      }

      // ...at this point, everything got read from the JSON backup file,
      // and all seems to be valid, so the contents from the temporary boxes
      // can be loaded into the actual hive boxes, depending on the backup
      // restoration strategy
      switch (strategy) {
        case BackupRestoreStrategy.replaceAll:
          // Load preferences
          await preferencesBox.put("theme", theme);
          LocalTheme.changeThemeMode(theme);

          await preferencesBox.put("currentBalance", currentBalance);

          await preferencesBox.put("everOpened", true);

          // Replace categories
          await categoryBox.clear();
          for (var key in tempCategoriesBox.keys) {
            Category? c = await tempCategoriesBox.get(key);
            if (c != null) {
              categoryBox.put(c.id, c);
            }
          }

          // Replace records
          await financialRecordBox.clear();
          for (var key in tempFinancialRecordsBox.keys) {
            FinancialRecord? r = await tempFinancialRecordsBox.get(key);
            if (r != null) {
              await financialRecordBox.put(r.id, r);
            }
          }

          // Replace categoriesOnRecords
          await categoryOnRecordBox.clear();
          for (var key in tempFinancialRecordsBox.keys) {
            CategoryOnRecord? cor = await tempCategoriesOnRecordsBox.get(key);
            if (cor != null) {
              await categoryOnRecordBox.put(cor.id, cor);
            }
          }

          break;
        case BackupRestoreStrategy.append:
          break;
        case BackupRestoreStrategy.forward:
      }

      // Finally, run the hooks required to make the current app's state react
      // to the changes in hive boxes
      // Load the currentBalance
      await InitService.initControllerFields();
    } catch (e) {
      throw "Backup file is invalid.";
    } finally {
      // Remove the temporary boxes
      await tempPreferencesBox.deleteFromDisk();
      await tempCategoriesBox.deleteFromDisk();
      await tempFinancialRecordsBox.deleteFromDisk();
      await tempCategoriesOnRecordsBox.deleteFromDisk();
    }
  }

  void _validateBackupMap(Map map) {
    String? missingField;
    if (!map.containsKey("preferences")) {
      missingField = "preferences";
    }

    if (!map.containsKey("categories")) {
      missingField = "categories";
    }

    if (!map.containsKey("financialRecords")) {
      missingField = "financialRecords";
    }

    if (!(map["financialRecords"] as Map).containsKey("expenses")) {
      missingField = "expenses";
    }
    if (!(map["financialRecords"] as Map).containsKey("incomes")) {
      missingField = "incomes";
    }

    if (missingField != null) {
      throw "Backup file is invalid. \"$missingField\" is missing";
    }
  }

  Future<Map> _loadBackupFromFile() async {
    // Let the user select the backup file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) {
      throw "No files were selected.";
    }

    File backupFile = File(result.files.single.path!);

    // Decode the json file into a map
    String backupJson = await backupFile.readAsString();
    return jsonDecode(backupJson);
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

enum BackupRestoreStrategy {
  replaceAll,
  forward,
  append,
}
