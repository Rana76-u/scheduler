import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_task.dart';

class AddTaskFloating extends StatelessWidget {

  const AddTaskFloating({
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
                  () => const AddTaskPage()
              );
            },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          label: const Text(
            'Add Task',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
          ),
          icon: const Icon(
              Icons.task_alt_rounded
          ),
        ),
      ),
    );
  }
}
