import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/playground.dart';
import 'package:quick_car/view/pages/cars_list/results_view.dart';
import 'package:quick_car/view/pages/map/map.dart';
import 'package:quick_car/view/pages/profile/profile.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final tabs = [ ResultsView(),
    GMap(), Profile(), PlayGroundPage()];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              backgroundColor: Colors.blue,
              title: Text("list view")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              backgroundColor: Colors.blue,
              title: Text("map view")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              backgroundColor: Colors.blue,
              title: Text("profile")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.adb),
              backgroundColor: Colors.blue,
              title: Text("playground")
          )],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

    );
  }
}
