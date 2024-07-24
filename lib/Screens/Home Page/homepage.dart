import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scheduler/API/hive_api.dart';
import 'package:scheduler/API/time_modifier.dart';
import 'package:scheduler/Screens/Home%20Page/home_floating.dart';
import 'package:scheduler/Widgets/bottom_nav.dart';
import '../../API/class_day.dart';
import '../../Models/Hive/Class/class.dart';
import '../CRUD/Class/crud_class.dart';

class HomePage extends StatefulWidget {
   const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Class> classList = [];
  bool isLoading = false;
  bool isTodaySelected = true;
  bool isAllClassesSelected = false;

  @override
  void initState() {
    getAllClasses();
    super.initState();
  }

  getAllClasses() async {

    setState(() {
      isLoading = true;
    });

    classList = HiveApi().getAllClasses();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scheduler',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                  fontFamily: 'Urbanist',
                  letterSpacing: 1.5,
                  color: Colors.deepOrange
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                radioWidget(isTodaySelected, 'Today'),
                radioWidget(isAllClassesSelected, 'All Classes')
              ],
            )
          ],
        ),
        titleSpacing: 30,
        toolbarHeight: 100,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const CRUDClassFloating(),
      body: isLoading ?
          const Center(
            child: CircularProgressIndicator(),
          )
          :
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              classesWidget(),
              const SizedBox(height: 150,)
            ],
          ),
        ),
      ),
    );
  }

  Widget classesWidget() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: classList.length,
      itemBuilder: (context, index) {

        List<int> classDays = classList[index].classDays;
        bool isToday = classDays.contains(DateTime.now().weekday);

        if(isTodaySelected){
          return isToday ?
            classWidget(index, classDays)
              :
            const SizedBox();
        }
        else{
          return classWidget(index, classDays);
        }
      },
    );
  }

  Widget infoTextWidget(String text) {
    return SelectableText(
      text,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }

  Widget radioWidget(bool isSelected, String text) {
    return RadioMenuButton(
        value: isSelected,
        groupValue: true,
        onChanged: (value) {
          setState(() {
              if(text == 'Today'){
                if(isTodaySelected == false){
                  isTodaySelected = true;
                  isAllClassesSelected = false;
                }
              }
              else if(text == 'All Classes'){
                if(isAllClassesSelected == false){
                  isTodaySelected = false;
                  isAllClassesSelected = true;
                }
              }
          });
        },
        child: Text(text)
    );
  }

  Widget classWidget(int index, List<int> classDays) {
    String startTime = localizeTimeToString(classList[index].classTime);
    TimeOfDay endTime = TimeOfDay(hour: classList[index].classTime.hour+1, minute: classList[index].classTime.minute+15);
    String classEndTime = localizeTimeToString(endTime);

    List tasks = classList[index].taskIds;
    String classStatus = compareTime(classList[index].classTime, endTime);

    return GestureDetector(
      onTap: () {
        Get.to(
                () => CRUDClass(classId: classList[index].classId,) //  XkMbO3AkVE
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
                color: classList[index].classColor,
                width: 1
            )
        ),
        //color: classList[index].classColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue.shade100
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title
                      Text(
                        '${classList[index].classTitle}  ',
                        style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            //color: classList[index].classColor
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //time
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                timeWidget(startTime, classEndTime),

                                //room, section
                                Row(
                                  children: [
                                    const Text(
                                      'Room No. : ',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    Text(
                                      classList[index].roomNumber,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const Text(
                                      '   Section : ',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    Text(
                                      classList[index].sectionNumber,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          SizedBox(
                            height: 25,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.resolveWith((states) => 0),
                                backgroundColor: MaterialStateColor.resolveWith((states) =>
                                classStatus == 'Done' ? Colors.green
                                    :
                                classStatus == 'Now' ? Colors.lightBlue
                                    :
                                Colors.red
                                ),
                              ),
                              child: Text(
                                classStatus
                                ,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),
                        ],
                      )
                    ],
                  ),


                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            '${classList[index].facultyName} (${classList[index].facultyInitial})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            //overflow: TextOverflow.clip,
                          ),

                          infoTextWidget('office hour : ${classList[index].facultyOfficeHour} (${classList[index].facultyOfficeLocation})'),

                          infoTextWidget('phone : ${classList[index].facultyPhoneNumber}'),

                          infoTextWidget('email : ${classList[index].facultyEmail}'),

                          //class days
                          Row(
                            children: [
                              infoTextWidget('class days : '),
                              SizedBox(
                                width: 100,
                                height: 35,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: classDays.length,
                                  itemBuilder: (context, index) {

                                    String day = getClassDayToString(classDays[index]);

                                    return Card(
                                      elevation: 0,
                                      color: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      child: Container(
                                        width: 27,
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Text(
                                            day,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 14
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    //task length
                    GestureDetector(
                      onTap: () {
                        Get.to(
                                () => BottomBar(currentIndex: 1)
                        );
                      },
                      child: SizedBox(
                        height: 75,
                        width: 80,
                        child: Stack(
                          children: [
                            Visibility(
                              visible: tasks.isEmpty ? false : true,
                              child: Positioned(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Text(
                                          '${tasks.length}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 19
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              top: 20,
                              left: 20,
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Card(
                                  elevation: 0,
                                  color: Colors.purple,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget timeWidget(String startTime, String classEndTime) {
    return Row(
      children: [
        const Text(
          'From ',
          style: TextStyle(
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        Text(
          startTime,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.5,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        const Text(
          ' To ',
          style: TextStyle(
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        Text(
          classEndTime,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.5,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
