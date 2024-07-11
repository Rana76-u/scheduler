import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:scheduler/Widgets/bottom_nav.dart';

import '../../Widgets/loading_overlay.dart';

class CRUDClass extends StatefulWidget {
  const CRUDClass({super.key});

  @override
  State<CRUDClass> createState() => _CRUDClassState();
}

class _CRUDClassState extends State<CRUDClass> {
  Color selectedColor = Colors.blue;
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

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
                  // todo: await uploadInfo();
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
                // todo
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
}
