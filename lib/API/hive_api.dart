import 'package:hive/hive.dart';
import 'package:scheduler/Models/Hive/Class/class.dart';
import 'package:scheduler/Models/Hive/Student/student.dart';
import 'package:scheduler/Models/Hive/Task/task.dart';

class HiveApi {

  Future<void> saveOrUpdateClass(Class classObject) async {
    final classBox = Hive.box<Class>('classes');
    classBox.put(classObject.classId, classObject);
  }

  Future<void> saveOrUpdateTask(Task taskObject) async {
    final classBox = Hive.box<Task>('tasks');
    classBox.put(taskObject.taskId, taskObject);
  }

  Future<void> saveOrUpdateStudent(Student studentObject) async {
    final studentBox = Hive.box<Student>('students');
    studentBox.put(studentObject.studentId, studentObject);
  }


  List<Class> getAllClasses() {
    final box = Hive.box<Class>('classes');
    final classes = box.values.toList();

    classes.sort(
        (a,b) {
          final aTime = a.classTime;
          final bTime = b.classTime;
          if(aTime.hour == bTime.hour){
            return aTime.minute.compareTo(bTime.minute);
          }
          return aTime.hour.compareTo(bTime.hour);
        }
    );

    return classes;
  }

  List<Task> getAllTasks() {
    final box = Hive.box<Task>('tasks');
    final tasks = box.values.toList();

    tasks.sort(
            (a,b) {
          final aTime = a.submitDate;
          final bTime = b.submitDate;
          if(aTime.hour == bTime.hour){
            return aTime.minute.compareTo(bTime.minute);
          }
          return aTime.hour.compareTo(bTime.hour);
        }
    );

    return tasks;
  }

  List<Student> getAllStudent() {
    final box = Hive.box<Student>('students');
    final students = box.values.toList();

    return students;
  }


  Future<Class?> getClass(String id) async {
    final classBox = Hive.box<Class>('classes');

    Class classObject = classBox.values.firstWhere((element) => element.classId == id);
    return classObject;
  }

  Future<Task?> getTask(String id) async {
    final taskBox = Hive.box<Task>('tasks');

    Task taskObject = taskBox.values.firstWhere((element) => element.taskId == id);
    return taskObject;
  }


  deleteClass(String classId) async {
    final classBox = Hive.box<Class>('classes');

    final classKey = classBox.keys.firstWhere(
            (key) {
              final classObject = classBox.get(key);
              return classObject!.classId == classId;
            },
            orElse: () => null,
    );

    if(classKey != null){
      await classBox.delete(classKey);
    }

  }

  deleteTask(String taskId) async {
    final taskBox = Hive.box<Task>('tasks');

    final classKey = taskBox.keys.firstWhere(
          (key) {
        final taskObject = taskBox.get(key);
        return taskObject!.taskId == taskId;
      },
      orElse: () => null,
    );

    if(classKey != null){
      await taskBox.delete(classKey);
    }
  }
}