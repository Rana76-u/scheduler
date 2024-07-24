import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scheduler/API/hive_api.dart';
import 'package:scheduler/Models/Hive/Class/class.dart';
import 'package:scheduler/Models/Hive/Task/task.dart';
import 'package:scheduler/Screens/CRUD/Task/add_task.dart';
import 'add_task_floating.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, });

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  List<Class> classList = [];
  List<Task> tasks = [];
  String selectedClassId = '';

  @override
  void initState() {
    getTasks();
    super.initState();
  }

  getTasks() {
    tasks = HiveApi().getAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        titleSpacing: 45,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const AddTaskFloating(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [

              //class name list
              classNamesWidget(),

              const SizedBox(height: 5,),

              //task list
              taskListWidget(),
            ],
          ),
        ),
      ),
    );
  }


  Widget classNamesWidget() {
    classList = HiveApi().getAllClasses();

    return SizedBox(
      height: 42,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if(selectedClassId == 'none'){
                  selectedClassId = '';
                }
                else{
                  selectedClassId = 'none';
                }
              });
            },
            child: Container(
              height: 50,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey.shade400,
                border: selectedClassId == 'none' ? Border.all(
                    color: Colors.black,
                    width: 2
                )
                    :
                Border.all(color: Colors.white),
              ),
              child: const Icon(Icons.notes_rounded, color: Colors.white,),
            ),
          ),

          const SizedBox(width: 5,),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: classList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if(selectedClassId == classList[index].classId){
                            selectedClassId = '';
                          }
                          else{
                            selectedClassId = classList[index].classId;
                          }
                        });
                      },
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: selectedClassId == classList[index].classId ? Border.all(
                                color: Colors.black,
                                width: 2
                            )
                                :
                            Border.all(
                              color: Colors.white
                            ),
                            color: classList[index].classColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Center(
                            child: Text(
                              classList[index].classTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
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
          )
        ],
      ),
    );
  }

  Widget taskListWidget() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {

        return selectedClassId == '' ?
          taskWidget(index)
            :
        selectedClassId == tasks[index].classId ?
        taskWidget(index)
            :
          const SizedBox();
      },
    );
  }

  Widget radioWidget(bool isComplete) {
    return RadioMenuButton(
        value: isComplete,
        groupValue: true,
        onChanged: (value) {
          setState(() {
            isComplete = !isComplete;
          });
        },
        child: isComplete ? const Text('Task Completed') : const Text('Pending')
    );
  }

  Widget taskTypesWidget(String taskType) {
    return SizedBox(
      height: 42,
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.deepPurple
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Center(
              child: Text(
                taskType,
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
  }

  Widget taskWidget(int index) {

    String className = '';
    Color classColor =  Colors.black;
    int daysLeft = DateTime.now().day - tasks[index].submitDate.day;
    int monthsLeft = DateTime.now().month - tasks[index].submitDate.month;

    for(int i=0; i<classList.length; i++){
      if(classList[i].classId == tasks[index].classId){
        className = classList[i].classTitle;
        classColor = classList[i].classColor;
        break;
      }
    }

    return GestureDetector(
      onTap: () {
        Get.to(
                () => AddTaskPage(taskID: tasks[index].taskId,)
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          padding: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //is complete, class name
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    radioWidget(tasks[index].isComplete),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Text(
                        className,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: classColor
                        ),
                      ),
                    )
                  ]
              ),
              //title, des, type
              Row(
                children: [
                  const SizedBox(width: 43,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tasks[index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                          overflow: TextOverflow.clip,
                        ),
                        Text(
                          tasks[index].description,
                          overflow: TextOverflow.clip,
                        ),
                    
                      ],
                    ),
                  ),
                  const Spacer(),
                  taskTypesWidget(tasks[index].taskType),
                  const SizedBox(width: 35,)
                ],
              ),
              //submit
              Row(
                children: [
                  const SizedBox(width: 43,),
                  const Text(
                      'Submission Date: '
                  ),
                  Text(
                    '${tasks[index].submitDate.day}-${tasks[index].submitDate.month}-${tasks[index].submitDate.year}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              //left
              Row(
                children: [
                  const SizedBox(width: 43,),
                  Text(
                    '${daysLeft.abs()} days',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                    ),
                  ),
                  monthsLeft != 0 ?
                  Text(
                    ' ${monthsLeft.abs()} months',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                    ),
                  )
                      :
                  const SizedBox(),

                  const Text(
                    ' left',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
