// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinancialRecordAdapter extends TypeAdapter<FinancialRecord> {
  @override
  final int typeId = 0;

  @override
  FinancialRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinancialRecord(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      date: fields[3] as DateTime,
      comment: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FinancialRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
