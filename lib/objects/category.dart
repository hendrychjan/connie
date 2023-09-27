import 'package:connie/getx/app_controller.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

// Generate script: dart run build_runner build

@HiveType(typeId: 3)
class Category {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(3)
  String colorHex;

  Category({
    required this.id,
    required this.title,
    required this.colorHex,
  });

  Future<void> save() async {
    await AppController.to.hiveService.categoryBox.put(id, this);
  }

  Future<void> delete() async {
    await AppController.to.hiveService.categoryBox.delete(id);
  }

  static Future<Category?> getById(String id) async {
    return AppController.to.hiveService.categoryBox.get(id);
  }
}
