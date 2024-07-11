import 'package:hive/hive.dart';

part 'class.g.dart';

@HiveType(typeId: 0, adapterName: 'ClassAdapter')
class Class extends HiveObject {
  @HiveField(0)
  String classId;

  @HiveField(1)
  String classTitle;

  @HiveField(2)
  String roomNumber;

  @HiveField(3)
  String sectionNumber;

  @HiveField(4)
  String facultyName;

  @HiveField(5)
  String facultyInitial;

  @HiveField(6)
  String facultyOfficeHour;

  @HiveField(7)
  String facultyOfficeLocation;

  @HiveField(8)
  String facultyPhoneNumber;

  @HiveField(9)
  String facultyEmail;

  @HiveField(10)
  DateTime classTime;

  @HiveField(11)
  DateTime classColor;

  @HiveField(12)
  String note;

  @HiveField(13)
  List taskIds;

  Class({
    required this.classId,
    required this.classTitle,
    required this.roomNumber,
    required this.sectionNumber,
    required this.facultyName,
    required this.facultyInitial,
    required this.facultyOfficeHour,
    required this.facultyOfficeLocation,
    required this.facultyPhoneNumber,
    required this.facultyEmail,
    required this.classTime,
    required this.classColor,
    required this.note,
    required this.taskIds,
  });
}