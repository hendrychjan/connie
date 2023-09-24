import 'package:connie/services/hive_service.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  HiveService hiveService = HiveService();
}
