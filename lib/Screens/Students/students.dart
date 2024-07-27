import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scheduler/API/hive_api.dart';
import 'package:scheduler/API/id_generator.dart';
import 'package:scheduler/Models/Hive/Student/student.dart';
import 'package:scheduler/Screens/Students/student_details.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {

  TextEditingController studentNameController = TextEditingController();
  List<Student> students = [];

  addStudent() async {
    Student studentObject = Student(
        studentId: generateId(),
        studentName: studentNameController.text,
        daysOfMonth: []
    );

    await HiveApi().saveOrUpdateStudent(studentObject);

    studentNameController.clear();
  }

  @override
  void initState() {
    students = HiveApi().getAllStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        titleSpacing: 20,
        toolbarHeight: 50,
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 200,
        child: FittedBox(
          child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text(
                          'Add Student'
                      ),
                      contentPadding: const EdgeInsets.all(15),
                      children: [
                        textFieldWidget(studentNameController, 'Input Name'),
                        ElevatedButton(
                          onPressed: () async {
                            final navigator = Navigator.pop(context);

                            // Refresh the screen
                            if (mounted) {
                              // Dismiss the dialog
                              navigator;
                            }

                            await addStudent();
                          },
                          child: const Text(
                              'Submit'
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            label: const Text(
              'Add Student',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            ),
            icon: const Icon(Icons.person_add_alt_rounded),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              studentNamesWidget(),

              const SizedBox(height: 100,),
            ],
          ),
        ),
      ),
    );
  }

  Widget studentNamesWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: students.length,
        itemBuilder: (context, index) {
          // Calculate the number of classes in the current week and month for the student
          DateTime now = DateTime.now();
          DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          DateTime endOfWeek = now.add(Duration(days: 7 - now.weekday));

          int classesInWeek = students[index].daysOfMonth
              .where((day) => day.isAfter(startOfWeek.subtract(const Duration(days: 1))) && day.isBefore(endOfWeek.add(const Duration(days: 1))))
              .length;

          int classesInMonth = students[index].daysOfMonth
              .where((day) => day.year == now.year && day.month == now.month)
              .length;

          // Check if today is in the daysOfMonth list
          bool isTodayAdded = students[index].daysOfMonth.contains(DateTime(now.year, now.month, now.day));

          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              onTap: () {
                // Navigate to StudentDetailPage
                Get.to(() => StudentDetailPage(student: students[index]));
              },
              leading: const Icon(Icons.person),
              title: Text(
                students[index].studentName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week: $classesInWeek',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'This Month: $classesInMonth',
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Today'),
                  Checkbox(
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          students[index].daysOfMonth.add(DateTime(now.year, now.month, now.day));
                        } else {
                          students[index].daysOfMonth.remove(DateTime(now.year, now.month, now.day));
                        }
                        students[index].save(); // Save the updated student object
                      });
                    },
                    value: isTodayAdded,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
              tileColor: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
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