// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_on_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryOnRecordAdapter extends TypeAdapter<CategoryOnRecord> {
  @override
  final int typeId = 4;

  @override
  CategoryOnRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryOnRecord(
      id: fields[0] as String,
      recordId: fields[1] as String,
      categoryId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryOnRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.recordId)
      ..writeByte(2)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryOnRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
