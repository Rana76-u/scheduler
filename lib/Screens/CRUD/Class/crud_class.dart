import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:scheduler/API/class_day.dart';
import 'package:scheduler/API/hive_api.dart';
import 'package:scheduler/API/id_generator.dart';
import 'package:scheduler/Models/Hive/Class/class.dart';
import 'package:scheduler/Widgets/bottom_nav.dart';

import '../../../Widgets/loading_overlay.dart';

class CRUDClass extends StatefulWidget {
  final String? classId;
  const CRUDClass({super.key, this.classId});

  @override
  State<CRUDClass> createState() => _CRUDClassState();
}

class _CRUDClassState extends State<CRUDClass> {
  bool isLoading = false;

  Color selectedColor = Colors.blue;
  TimeOfDay selectedTime = TimeOfDay.now();
  List<int> classDays = [];

  List taskIds = [];

  TextEditingController classTitleController = TextEditingController();
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController facultyNameController = TextEditingController();
  TextEditingController facultyInitialController = TextEditingController();
  TextEditingController facultyOfficeHourController = TextEditingController();
  TextEditingController facultyOfficeLocationController = TextEditingController();
  TextEditingController facultyPhoneNumberController = TextEditingController();
  TextEditingController facultyEmailController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    if(widget.classId != null) {
       loadClassDetails();
    }
    super.initState();
  }

  void loadClassDetails() async {

    setState(() {
      isLoading = true;
    });

    Class? classObject = await HiveApi().getClass(widget.classId!);

    if(classObject != null){
      classTitleController.text = classObject.classTitle;
      roomNumberController.text = classObject.roomNumber;
      sectionController.text = classObject.sectionNumber;
      facultyNameController.text = classObject.facultyName;
      facultyInitialController.text = classObject.facultyInitial;
      facultyOfficeHourController.text = classObject.facultyOfficeHour;
      facultyOfficeLocationController.text = classObject.facultyOfficeLocation;
      facultyPhoneNumberController.text = classObject.facultyPhoneNumber;
      facultyEmailController.text = classObject.facultyEmail;
      selectedTime = classObject.classTime;
      classDays = classObject.classDays;
      selectedColor = classObject.classColor;
      noteController.text = classObject.note;
      taskIds = classObject.taskIds;
    }
    /*else{
      messenger.showSnackBar(
          const SnackBar(
              content: Text('An Error Occurred')
          )
      );
    }*/

    setState(() {
      isLoading = false;
    });
  }

  void onClickSave() async {
    setState(() {
      isLoading = true;
    });

    String id = widget.classId ?? generateId();

    Class classObject = Class(
        classId: id,
        classTitle: classTitleController.text,
        roomNumber: roomNumberController.text,
        sectionNumber: sectionController.text,
        facultyName: facultyNameController.text,
        facultyInitial: facultyInitialController.text,
        facultyOfficeHour: facultyOfficeHourController.text,
        facultyOfficeLocation: facultyOfficeLocationController.text,
        facultyPhoneNumber: facultyPhoneNumberController.text,
        facultyEmail: facultyEmailController.text,
        classTime: selectedTime,
        classDays: classDays,
        classColor: selectedColor,
        note: noteController.text,
        taskIds: []
    );

    HiveApi().saveOrUpdateClass(classObject);

    setState(() {
      isLoading = false;
    });

    Get.to(
        () => BottomBar(currentIndex: 0)
    );
  }

  void onClickDelete() async {
    setState(() {
      isLoading = false;
    });

    if(widget.classId != null){
      HiveApi().deleteClass(widget.classId!);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.to(() => BottomBar(currentIndex: 0,), transition: Transition.fade);
              },
              child: const Icon(Icons.arrow_back),
          ),
          title: const Text(
              'Class',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          actions: [
            //Save Button
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ElevatedButton(
                onPressed: () async {
                  onClickSave();
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

            //3Dot Icon
            GestureDetector(
              onTap: () {
                if(widget.classId != null){
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
                              onClickDelete();

                              /*setState(() {
                                _isLoading = false;
                              });*/
                              //to home
                              Get.to(
                                      () => BottomBar(currentIndex: 0),
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
                      content: Text("The Class hasn't been created yet"))
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(
                    Icons.delete_forever_rounded
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
                const SizedBox(height: 30,),

                textFieldWidget(classTitleController, 'Class Title'),
                textFieldWidget(roomNumberController, 'Room Number'),
                textFieldWidget(sectionController, 'Section'),
                textFieldWidget(facultyNameController, 'Faculty Name'),
                textFieldWidget(facultyInitialController, 'Faculty Initial'),
                textFieldWidget(facultyOfficeHourController, 'Faculty Office Hour'),
                textFieldWidget(facultyOfficeLocationController, 'Faculty Office Location'),
                textFieldWidget(facultyPhoneNumberController, 'Faculty Phone Number'),
                textFieldWidget(facultyEmailController, 'Faculty Email'),
                textFieldWidget(noteController, 'Note'),

                //pick time
                pickTimeWidget(),

                const SizedBox(height: 10,),

                //Select Class Days
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                      'Choose Class Days',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                classDaysWidget(),

                const SizedBox(height: 5,),

                //pick color
                pickColorWidget(),

                const SizedBox(height: 150,)
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(TextEditingController textEditingController, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint),
        Padding(
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
        )
      ],
    );
  }

  Widget pickColorWidget() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pick a color'),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Pick A BackGround Color : '),

          const SizedBox(width: 10,),

          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 25,
              width: 25,
              color: selectedColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget pickTimeWidget() {
    return ElevatedButton(
      onPressed: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );
        if (picked != null && picked != selectedTime) {
          setState(() {
            selectedTime = picked;
          });
        }
      },
      child: Text('Set Class Time : ${selectedTime.format(context)}'),
    );
  }

  Widget classDaysWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) {
            String day = getClassDayToString(index);
            

            return GestureDetector(
              onTap: () {
                setState(() {
                  classDays.contains(index) ? classDays.remove(index) : classDays.add(index);
                });
              },
              child: Card(
                elevation: 0,
                color: classDays.contains(index) ? Colors.black : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Container(
                  height: 50,
                  width: 40,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                        day,
                      style: TextStyle(
                        color: classDays.contains(index) ? Colors.white : Colors.black
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
