import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scheduler/API/hive_api.dart';
import 'package:scheduler/Models/Hive/Student/student.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Widgets/bottom_nav.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;
  const StudentDetailPage({super.key, required this.student});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  TextEditingController studentNameController = TextEditingController();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      if (widget.student.daysOfMonth.contains(day)) {
        widget.student.daysOfMonth.remove(day);
      } else {
        widget.student.daysOfMonth.add(day);
      }
      widget.student.save(); // Save the updated student object
    });
  }

  int _classesInCurrentMonth() {
    DateTime now = DateTime.now();
    return widget.student.daysOfMonth
        .where((day) => day.year == now.year && day.month == now.month)
        .length;
  }

  int _classesInCurrentWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = now.add(Duration(days: 7 - now.weekday));

    return widget.student.daysOfMonth
        .where((day) => day.isAfter(startOfWeek.subtract(const Duration(days: 1))) && day.isBefore(endOfWeek.add(const Duration(days: 1))))
        .length;
  }

  @override
  void initState() {
    studentNameController.text = widget.student.studentName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.to(
                () => BottomBar(currentIndex: 2)
            );
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text("Are you sure you want to delete?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Dismiss the dialog
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            final navigator = Navigator.pop(context);

                            // Dismiss the dialog
                            if (mounted) {
                              navigator;
                            }
                            // Perform the delete action
                            await HiveApi().deleteStudent(widget.student.studentId);

                            Get.to(
                                    () => BottomBar(currentIndex: 2),
                                transition: Transition.fade
                            );
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                  Icons.delete,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50,),

              textFieldWidget(studentNameController, 'Name'),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Classes this month: ${_classesInCurrentMonth()}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Classes this week: ${_classesInCurrentWeek()}'),
              ),

              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                selectedDayPredicate: (day) {
                  return widget.student.daysOfMonth.contains(day);
                },
                onDaySelected: _onDaySelected
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(TextEditingController textEditingController, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            minHeight: 60,
            maxHeight: 150
        ),
        //height: 60,
        child: TextField(
          onChanged: (value) async {
            Student tempStudent = Student(
                studentId: widget.student.studentId,
                studentName: studentNameController.text,
                daysOfMonth: widget.student.daysOfMonth
            );

            await HiveApi().saveOrUpdateStudent(tempStudent);
          },
          controller: textEditingController,
          autofocus: true,
          autocorrect: false,
          maxLines: null,
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
            prefixIcon: const Icon(
              Icons.short_text_rounded,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            hintText: hint,
          ),
          cursorColor: Colors.black,
        ),
      ),
    );
  }
}
