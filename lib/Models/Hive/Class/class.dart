import 'package:flutter/material.dart';
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
  TimeOfDay classTime;

  @HiveField(11)
  List<int> classDays;

  @HiveField(12)
  Color classColor;

  @HiveField(13)
  String note;

  @HiveField(14)
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
    required this.classDays,
    required this.classColor,
    required this.note,
    required this.taskIds,
  });
}