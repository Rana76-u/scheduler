// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassAdapter extends TypeAdapter<Class> {
  @override
  final int typeId = 0;

  @override
  Class read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class(
      classId: fields[0] as String,
      classTitle: fields[1] as String,
      roomNumber: fields[2] as String,
      sectionNumber: fields[3] as String,
      facultyName: fields[4] as String,
      facultyInitial: fields[5] as String,
      facultyOfficeHour: fields[6] as String,
      facultyOfficeLocation: fields[7] as String,
      facultyPhoneNumber: fields[8] as String,
      facultyEmail: fields[9] as String,
      classTime: fields[10] as DateTime,
      classColor: fields[11] as DateTime,
      note: fields[12] as String,
      taskIds: (fields[13] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Class obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.classId)
      ..writeByte(1)
      ..write(obj.classTitle)
      ..writeByte(2)
      ..write(obj.roomNumber)
      ..writeByte(3)
      ..write(obj.sectionNumber)
      ..writeByte(4)
      ..write(obj.facultyName)
      ..writeByte(5)
      ..write(obj.facultyInitial)
      ..writeByte(6)
      ..write(obj.facultyOfficeHour)
      ..writeByte(7)
      ..write(obj.facultyOfficeLocation)
      ..writeByte(8)
      ..write(obj.facultyPhoneNumber)
      ..writeByte(9)
      ..write(obj.facultyEmail)
      ..writeByte(10)
      ..write(obj.classTime)
      ..writeByte(11)
      ..write(obj.classColor)
      ..writeByte(12)
      ..write(obj.note)
      ..writeByte(13)
      ..write(obj.taskIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
