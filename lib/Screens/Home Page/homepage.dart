import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scheduler/Screens/CRUD%20Class/crud_class.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(
                () => const CRUDClass(classId: 'XkMbO3AkVE',)
            );
          },
          child: const Text('Get Class'),
        ),
      ),
    );
  }
}
