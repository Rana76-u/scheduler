import 'package:flutter/material.dart';
import 'package:scheduler/Screens/CRUD%20Class/crud_class.dart';
import '../Screens/Home Page/homepage.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  late int currentIndex;
  BottomBar({super.key, required this.currentIndex});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  Widget? check(){
    if(widget.currentIndex == 0){
      return const HomePage();
    }
    else if(widget.currentIndex == 1){
      return const CRUDClass();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: check(),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: widget.currentIndex,
        itemPadding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        margin: const EdgeInsets.all(20),
        duration: const Duration(milliseconds: 400),
        onTap: (i) {
          setState(() {
            widget.currentIndex = i;
          });
        },
        unselectedItemColor: Colors.grey,
        items: [
          /// Classes
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_filled,),
            title: const Text("Home"),
            selectedColor: Colors.red,
          ),

          /// Tasks
          SalomonBottomBarItem(
            icon: const Icon(Icons.task_rounded),
            title: const Text("Task"),
            selectedColor: Colors.pink,
          ),
        ],
      ),
    );
  }
}