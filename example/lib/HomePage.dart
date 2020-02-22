import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:firebase_ml_vision_example/views/result_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children = [

    ResultPage(),
    HomePage(),

  ];


  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.black,
          elevation: 5,
          iconSize: 30,

          items: [
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.calendar),
              title: Text("camera"),
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.wheelchair),
              title: Text("result"),
            ),


          ],
        ),
        body: _children[_currentIndex]
    );
  }
}