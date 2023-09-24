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

  Category(
    this.id,
    this.title,
    this.colorHex,
  );

  Future<void> save() async {
    await AppController.to.hiveService.categoryBox!.put(id, this);
  }

  static Future<Category?> getById(String id) async {
    return AppController.to.hiveService.categoryBox!.get(id);
  }
}
