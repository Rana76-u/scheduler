import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 2, adapterName: 'StudentAdapter')
class Student extends HiveObject {
  @HiveField(0)
  String studentId;

  @HiveField(1)
  String studentName;

  @HiveField(2)
  List daysOfMonth;

  Student({
    required this.studentId,
    required this.studentName,
    required this.daysOfMonth
});
}