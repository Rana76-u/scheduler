import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scheduler/Screens/CRUD/Class/crud_class.dart';

class CRUDClassFloating extends StatelessWidget {

  const CRUDClassFloating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 200,
      child: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: () {
              Get.to(
                  () => const CRUDClass()
              );
            },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          label: const Text(
            'Add Class',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
          ),
          icon: const Icon(
              Icons.class_rounded
          ),
        ),
      ),
    );
  }
}
