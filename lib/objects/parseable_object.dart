import 'package:hive/hive.dart';

abstract class ParseableObject {
  String get id;

  factory ParseableObject.fromMap(Map map) {
    throw UnimplementedError(
      "Subclass must implement the 'fromMap()' factory constructor.",
    );
  }

  Map toMap();

  static Future<void> parseMapsIntoBox<T extends ParseableObject>(
    List maps,
    T Function(Map) fromMap, {
    Box? box,
    LazyBox? lazyBox,
    Future<void> Function(T)? validator,
  }) async {
    if (box == null && lazyBox == null) {
      throw ArgumentError("Either a box, or a lazyBox must be provided.");
    }

    for (Map map in maps) {
      T t = fromMap(map);
      if (validator != null) {
        await validator(t);
      }
      if (box != null) {
        await box.put(t.id, t);
      } else {
        await lazyBox!.put(t.id, t);
      }
    }
  }
}
