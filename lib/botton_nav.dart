import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/view/pages/login/login.dart';
import 'package:quick_car/view/pages/map/map.dart';
import 'package:quick_car/view/pages/profile/profile.dart';
import 'package:quick_car/view/results_view.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final tabs = [ ResultsPage(),
    GMap(), Profile(), Login()];
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
