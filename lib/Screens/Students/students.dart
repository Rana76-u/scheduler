import 'package:flutter/material.dart';
import 'package:scheduler/API/class_day.dart';
import 'package:scheduler/API/hive_api.dart';
import 'package:scheduler/API/id_generator.dart';
import 'package:scheduler/Models/Hive/Student/student.dart';

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

  updateStudent(Student student, int dayOfMonth) async {

    List tempDaysOfMonth = student.daysOfMonth;

    if(tempDaysOfMonth.contains(dayOfMonth)){
      tempDaysOfMonth.remove(dayOfMonth);
    }
    else{
      tempDaysOfMonth.add(dayOfMonth);
    }

    Student studentObject = Student(
        studentId: student.studentId,
        studentName: student.studentName,
        daysOfMonth: tempDaysOfMonth
    );

    await HiveApi().saveOrUpdateStudent(studentObject);

    setState(() {

    });
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
          'Students',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        titleSpacing: 20,
        toolbarHeight: 50,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              studentNamesWidget(),

              const SizedBox(height: 25,),

              weeksWidget(),

              calender()
            ],
          ),
        ),
      ),
    );
  }

  Widget studentNamesWidget() {

    return SizedBox(
      height: 75,
      child: Row(
        children: [

          //Add Students
          GestureDetector(
            onTap: () {
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
                        onPressed: () {
                          final navigator = Navigator.pop(context);
                          // Dismiss the dialog
                          if (mounted) {
                            navigator;
                          }
                          setState(() {
                            addStudent();
                          });
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
            child: Container(
              height: 75,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.deepPurple,
              ),
              child: const Icon(Icons.person_add_alt_rounded, color: Colors.white,),
            ),
          ),

          const SizedBox(width: 5,),

          //List of Students
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade200
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                students[index].studentName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                'This Week: ',
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'This Month: ${students[index].daysOfMonth.length}',
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
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

  Widget weeksWidget() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListTile(
            tileColor: Colors.deepPurple.shade100,//deepPurple[(index+1)*100],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            title: Text(
                nameOfWeekDays(index),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                //color: Colors.white
              ),
            ),
            subtitle: SizedBox(
              height: 35,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      onTap: () {
                        //todo save update
                      },
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.shade200
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                          child: Center(
                            child: Text(
                              students[index].studentName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget calender() {
    return CalendarDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2030),
        currentDate: DateTime.now(),
        onDateChanged: (value) {
          print(value);
        },
    );
  }
}
