import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scheduler/API/hive_api.dart';
import 'package:scheduler/API/id_generator.dart';
import 'package:scheduler/Models/Hive/Task/task.dart';
import 'package:scheduler/Widgets/bottom_nav.dart';
import '../../../Models/Hive/Class/class.dart';

class AddTaskPage extends StatefulWidget {
  final String? taskID;
  const AddTaskPage({super.key, this.taskID});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  List taskTypes = ['Others', 'Assignment', 'Presentation', 'Speech',
                    'Quiz', 'Mid', 'Final'];
  DateTime selectedDateTime = DateTime.now();
  bool isComplete = false;
  String selectedTaskType = 'Others';
  List<Class> classes = [];
  int selectedClassIndex = -1;

  String classIdOfTask = '';

  saveTask() async {
    if(taskTitleController.text.isNotEmpty){

      String generatedTaskID = generateId();

      Task taskObject = Task(
          taskId: widget.taskID ?? generatedTaskID,
          classId: selectedClassIndex == -1 ? 'none' : classes[selectedClassIndex].classId,
          title: taskTitleController.text,
          description: taskDescriptionController.text,
          taskType: selectedTaskType,
          submitDate: selectedDateTime,
          isComplete: isComplete
      );
      HiveApi().saveOrUpdateTask(taskObject);

      if(selectedClassIndex != -1){
        List tempTaskIds = classes[selectedClassIndex].taskIds;
        tempTaskIds.add(generatedTaskID);

        Class tempClass = Class(
            classId: classes[selectedClassIndex].classId,
            classTitle: classes[selectedClassIndex].classTitle,
            roomNumber: classes[selectedClassIndex].roomNumber,
            sectionNumber: classes[selectedClassIndex].sectionNumber,
            facultyName: classes[selectedClassIndex].facultyName,
            facultyInitial: classes[selectedClassIndex].facultyInitial,
            facultyOfficeHour: classes[selectedClassIndex].facultyOfficeHour,
            facultyOfficeLocation: classes[selectedClassIndex].facultyOfficeLocation,
            facultyPhoneNumber: classes[selectedClassIndex].facultyPhoneNumber,
            facultyEmail: classes[selectedClassIndex].facultyEmail,
            classTime: classes[selectedClassIndex].classTime,
            classDays: classes[selectedClassIndex].classDays,
            classColor: classes[selectedClassIndex].classColor,
            note: classes[selectedClassIndex].note,
            taskIds: tempTaskIds
        );

        HiveApi().saveOrUpdateClass(tempClass);
      }

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task Saved'))
      );
      
      Get.to(
          () => BottomBar(currentIndex: 1)
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title Is Required'))
      );
    }
  }

  deleteTask() async {
    final messenger = ScaffoldMessenger.of(context);
    if(widget.taskID!.isNotEmpty){

      await HiveApi().deleteTask(widget.taskID!);

      if(classIdOfTask != 'none'){

        for(int i=0; i<classes.length; i++){
          if(classIdOfTask == classes[i].classId){
            selectedClassIndex = i;
            break;
          }
        }

        List tempTaskIds = classes[selectedClassIndex].taskIds;
        tempTaskIds.remove(widget.taskID);

        Class tempClass = Class(
            classId: classes[selectedClassIndex].classId,
            classTitle: classes[selectedClassIndex].classTitle,
            roomNumber: classes[selectedClassIndex].roomNumber,
            sectionNumber: classes[selectedClassIndex].sectionNumber,
            facultyName: classes[selectedClassIndex].facultyName,
            facultyInitial: classes[selectedClassIndex].facultyInitial,
            facultyOfficeHour: classes[selectedClassIndex].facultyOfficeHour,
            facultyOfficeLocation: classes[selectedClassIndex].facultyOfficeLocation,
            facultyPhoneNumber: classes[selectedClassIndex].facultyPhoneNumber,
            facultyEmail: classes[selectedClassIndex].facultyEmail,
            classTime: classes[selectedClassIndex].classTime,
            classDays: classes[selectedClassIndex].classDays,
            classColor: classes[selectedClassIndex].classColor,
            note: classes[selectedClassIndex].note,
            taskIds: tempTaskIds
        );

        HiveApi().saveOrUpdateClass(tempClass);
      }

      messenger.showSnackBar(
          const SnackBar(content: Text('Task Deleted'))
      );
    }
  }

  @override
  void initState() {
    getClasses();
    getTask();
    super.initState();
  }

  void getClasses() {
    classes = HiveApi().getAllClasses();
  }

  void getTask() async {
    Task? task = await HiveApi().getTask(widget.taskID!);

    taskTitleController.text = task!.title;
    taskDescriptionController.text = task.description;
    selectedTaskType = task.taskType;
    selectedDateTime = task.submitDate;
    isComplete = task.isComplete;

    for(int i=0; i<classes.length; i++){
      if(task.classId == classes[i].classId){
        selectedClassIndex = i;
        break;
      }
    }

    classIdOfTask = task.classId;

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
         'Create/Edit Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
          actions: [
            //Save Button
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: ElevatedButton(
                onPressed: () async {
                  saveTask();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xFF8F00FF))),
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            //Delete
            GestureDetector(
              onTap: () {
                if(widget.taskID != null){
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
                              /*setState(() {
                                _isLoading = true;
                              });*/
                              // Dismiss the dialog
                              if (mounted) {
                                navigator;
                              }
                              // Perform the delete action
                              deleteTask();

                              /*setState(() {
                                _isLoading = false;
                              });*/
                              //to home
                              Get.to(
                                      () => BottomBar(currentIndex: 1),
                                  transition: Transition.fade
                              );
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                }
                //if the docId is null that means creating new post
                else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text("The task hasn't been created yet"))
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(
                    Icons.delete_forever_rounded,
                  color: Colors.red,
                ),
              ),
            )
          ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              radioWidget(),
              textFieldWidget(taskTitleController, 'Task Title'),
              textFieldWidget(taskDescriptionController, 'Task Description'),
              normalText('Task Type'),
              taskTypesWidget(),
              const SizedBox(height: 10,),
              dateTimePicker(),
              const SizedBox(height: 10,),
              normalText('Choose Class'),
              classesWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget radioWidget() {
    return RadioMenuButton(
        value: isComplete,
        groupValue: true,
        onChanged: (value) {
          setState(() {
            isComplete = !isComplete;
          });
        },
        child: const Text('Mark As Complete')
    );
  }

  Widget textFieldWidget(TextEditingController textEditingController, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
          ),
          const SizedBox(height: 3,),
          ConstrainedBox(
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
          )
        ],
      ),
    );
  }

  Widget taskTypesWidget() {
    return SizedBox(
      height: 42,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: taskTypes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTaskType = taskTypes[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: selectedTaskType == taskTypes[index] ? Border.all(
                          color: Colors.black,
                          width: 2
                      )
                          :
                      const Border(),
                    color: Colors.grey.shade200
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Center(
                      child: Text(
                        taskTypes[index],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget normalText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(text),
    );
  }

  Widget dateTimePicker() {
    return ElevatedButton(
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
              context: context,
              firstDate: DateTime(2024),
              lastDate: DateTime(2027),
          );

          setState(() {
            selectedDateTime = picked!;
          });
        },
        child: Text('Submit Date : ${selectedDateTime.day}-${selectedDateTime.month}-${selectedDateTime.year}')
    );
  }

  Widget classesWidget() {
    return SizedBox(
      height: 42,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: classes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if(selectedClassIndex == index){
                      selectedClassIndex = -1;
                    }
                    else{
                      selectedClassIndex = index;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: selectedClassIndex == index ? Border.all(
                          color: Colors.black,
                          width: 2
                      )
                          :
                      const Border(),
                      color: classes[index].classColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Center(
                      child: Text(
                        classes[index].classTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
