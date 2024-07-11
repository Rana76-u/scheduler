import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1, adapterName: 'TaskAdapter')
class Task extends HiveObject {
  @HiveField(0)
  String taskId;

  @HiveField(1)
  String classId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  String taskType;

  @HiveField(5)
  DateTime submitDate;

  @HiveField(6)
  bool isComplete;

  Task({
    required this.taskId,
    required this.classId,
    required this.title,
    required this.description,
    required this.taskType,
    required this.submitDate,
    required this.isComplete,
  });
}