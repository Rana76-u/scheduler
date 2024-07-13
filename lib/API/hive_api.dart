import 'package:hive/hive.dart';
import 'package:scheduler/Models/Hive/Class/class.dart';

class HiveApi {

  Future<void> saveOrUpdateClass(Class classObject) async {
    final classBox = Hive.box<Class>('classes');
    classBox.put(classObject.classId, classObject);
  }

  Future<Class?> getClass(String id) async {
    final classBox = Hive.box<Class>('classes');

    Class classObject = classBox.values.firstWhere((element) => element.classId == id);
    return classObject;
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

}