import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:scheduler/Models/Hive/Class/class.dart';
import 'package:scheduler/Models/Hive/Task/task.dart';
import 'Widgets/bottom_nav.dart';


Future<void> checkHiveBoxes() async {
  Hive.registerAdapter(ClassAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(ColorAdapter());
  if(!Hive.isBoxOpen('classes')) {

    await Hive.openBox<Class>('classes');
  }

  Hive.registerAdapter(TaskAdapter());
  if(!Hive.isBoxOpen('tasks')) {

    await Hive.openBox<Task>('tasks');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await checkHiveBoxes();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Urbanist',
      ),
      debugShowCheckedModeBanner: false,
      home: BottomBar(currentIndex: 1,), //todo: 0
    );
  }
}



