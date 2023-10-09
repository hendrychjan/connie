import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/category_on_record.dart';
import 'package:connie/objects/expense.dart';
import 'package:connie/objects/income.dart';
import 'package:connie/objects/parseable_object.dart';
import 'package:connie/services/hive_service.dart';
import 'package:connie/services/init_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Provides two public methods to backup the application data, and then
/// restore it using a given restore strategy
///
/// If any functionality is implemented, one that makes any kind of changes in
/// the app's storage, it should immediatelly be included in the backup/restore
/// service
///
/// For better navigation around implementing a backup/restore functionality for
/// a feature, below is a brief explanation of how each works. However, when
/// implementing something new into the backup, the best way is to just start
/// from the public method, and then go along the outline of it. Each necessary
/// step is explained in the sub-functions.
///
/// ### Restore
///
/// There are three possible backup restoration strategies:
///
/// 1. replaceAll - all the current application data will get replaced with the
/// backup
/// 2. forward - current state and backup data will be merged together, but the
/// backup state will be treated as newest, so if there are two versions of
/// something, the one from the backup file will be used
/// 3. append - this is the opposite of the "forward" strategy
///
/// ### Error handling
/// Each sub-function handles it's internal errors, makes sure to do stuff
/// like cleanup, and then throws an exception that is simply a description
/// of what went wrong, which can be then thrown again in the public function
/// and caught from where the backup/restore procedure was initially called,
/// and handled there accordingly, showing the error message to the user.
class BackupService {
  // These boxes should basically mirror the boxes that are used in the Hive
  // service
  late Box tempPreferencesBox;
  late LazyBox tempCategoryBox;
  late LazyBox tempFinancialRecordBox;
  late LazyBox tempCategoryOnRecordBox;

  Future<void> restoreApplicationData(MergeStrategy strategy) async {
    // Read the file that contains the backup. Nothing to do here, really, when
    // implementing something new
    Map backup = await _loadBackupFromFile();

    // Quickly validate the basic structure of the map that has been parsed from
    // the backup file. When new properties are added to the app's functionality
    // (e.g. a new type of financial record is added), you should definitely
    // make sure to add them here
    _validateBackupMap(backup);

    // Parse the contents of the backup map into corresponding objects, and save
    // those into temporary hive boxes. When adding a new feature, you should
    // definitely add stuff here
    await _loadBackupIntoStorage(backup);

    // Depending on the strategy, apply the backup data into the app's current
    // storage
    await _applyBackup(strategy);

    // Clear the temp storage, because it is no longer needed
    await _clearTempStorage();

    // Finally, run the hooks required to make the current app's state react
    // to the changes in hive boxes
    await InitService.initControllerFields();
    InitService.initAppTheme();
  }

  /// Let the user select a file that contains the backup, and then decode it
  /// from json to a map
  Future<Map> _loadBackupFromFile() async {
    // Let the user select the backup file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) {
      throw "No file was selected.";
    }

    File backupFile = File(result.files.single.path!);

    // Decode the json file into a map
    String backupJson = await backupFile.readAsString();
    return jsonDecode(backupJson);
  }

  /// Check the basic structure of the JSON map that contains the backup data
  void _validateBackupMap(Map map) {
    try {
      // Root level
      _validateMapKeys(map, ["preferences", "categories", "financialRecords"]);

      // Financial records
      _validateMapKeys(map["financialRecords"], ["expenses", "incomes"]);
    } catch (e) {
      throw "Backup is invalid. Field $e is missing";
    }
  }

  /// Parse all the objects from the backup map into actual class instances, and
  /// load them into the temporary hive boxes
  Future<void> _loadBackupIntoStorage(Map backup) async {
    // NOTE: this should be looked into when implementing new feature
    await _prepareTempStorage();

    // Now, just parse everything from the backup file into the temp storage
    // ..and of course, make sure to implement handling for new fields, if you
    // add some
    try {
      // Decode preferences
      Map preferences = backup["preferences"] as Map;

      String theme = preferences["theme"];
      double currentBalance =
          double.parse(preferences["currentBalance"].toString());

      await tempPreferencesBox.put("theme", theme);
      await tempPreferencesBox.put("currentBalance", currentBalance);

      // Decode categories
      await ParseableObject.parseMapsIntoBox<Category>(
        backup["categories"] as List,
        Category.fromMap,
        lazyBox: tempCategoryBox,
      );

      // Decode expenses
      await ParseableObject.parseMapsIntoBox<Expense>(
        backup["financialRecords"]["expenses"] as List,
        Expense.fromMap,
        lazyBox: tempFinancialRecordBox,
      );

      // Decode incomes
      await ParseableObject.parseMapsIntoBox<Income>(
        backup["financialRecords"]["incomes"] as List,
        Income.fromMap,
        lazyBox: tempFinancialRecordBox,
      );

      // Decode categories on records
      await ParseableObject.parseMapsIntoBox<CategoryOnRecord>(
          backup["categoriesOnRecords"] as List, CategoryOnRecord.fromMap,
          lazyBox: tempCategoryOnRecordBox,
          validator: (CategoryOnRecord cor) async {
        if (!tempCategoryBox.containsKey(cor.categoryId)) {
          throw "Missing category in category_on_record relationship.";
        }
        if (!tempFinancialRecordBox.containsKey(cor.recordId)) {
          throw "Missing record in category_on_record relationship.";
        }
      });
    } catch (e) {
      await _clearTempStorage();
      throw "Failed to decode the backup fields.";
    }
  }

  /// Prepare all hive boxes that will hold the data temporalily, just during
  /// the
  Future<void> _prepareTempStorage() async {
    // Create hive boxes. Into those, objects from the backup json will be
    // loaded temporarily
    tempPreferencesBox = await Hive.openBox("tmp_preferences");
    tempCategoryBox = await Hive.openLazyBox("tmp_category");
    tempFinancialRecordBox = await Hive.openLazyBox("tmp_financialRecord");
    tempCategoryOnRecordBox = await Hive.openLazyBox("tmp_categoryOnRecord");

    // Clear the boxes, in case there were some left over from a previous
    // unsuccessfull backup restore
    await tempPreferencesBox.clear();
    await tempCategoryBox.clear();
    await tempFinancialRecordBox.clear();
    await tempCategoryOnRecordBox.clear();
  }

  /// Remove all temporary Hive boxes, no matter if the restore was successfull
  /// or not - these would take up unnecessary space on the disk
  Future<void> _clearTempStorage() async {
    // Remove the temporary boxes
    await tempPreferencesBox.deleteFromDisk();
    await tempCategoryBox.deleteFromDisk();
    await tempFinancialRecordBox.deleteFromDisk();
    await tempCategoryOnRecordBox.deleteFromDisk();
  }

  /// Merge the backup data and the app's current state
  Future<void> _applyBackup(MergeStrategy strategy) async {
    // Preferences
    Box preferencesBox = AppController.to.hiveService.preferencesBox;
    await HiveService.copyBox<Box>(
      keys: ["theme", "currentBalance", "everOpened"],
      sourceBox: tempPreferencesBox,
      destination: preferencesBox,
      strategy: strategy,
    );

    // Categories
    Box categoryBox = AppController.to.hiveService.categoryBox;
    await HiveService.copyBox<Box>(
      sourceLazyBox: tempCategoryBox,
      destination: categoryBox,
      strategy: strategy,
    );

    // Financial records
    LazyBox financialRecordBox =
        AppController.to.hiveService.financialRecordBox;
    await HiveService.copyBox<LazyBox>(
      sourceLazyBox: tempFinancialRecordBox,
      destination: financialRecordBox,
      strategy: strategy,
    );

    // Categories on expenses
    LazyBox corBox = AppController.to.hiveService.categoryOnRecordBox;
    await HiveService.copyBox<LazyBox>(
      sourceLazyBox: tempCategoryOnRecordBox,
      destination: corBox,
      strategy: strategy,
    );
  }

  /// A helper function that checks if requiredKeys are present in the map
  void _validateMapKeys(Map map, List<String> requiredKeys) {
    for (String key in requiredKeys) {
      if (!map.containsKey(key)) throw key;
    }
  }
}

enum MergeStrategy {
  replaceAll,
  forward,
  append,
}
