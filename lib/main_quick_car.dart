
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:quick_car/models/category_model.dart';
import 'package:quick_car/models/news_model.dart';
import 'package:quick_car/view/search_view.dart';

import 'api/api.dart';
import 'view/car_listview/car_listview.dart';
import 'models/car_model.dart';


class SearchPage extends StatefulWidget {
  @override
  QuickCar createState() => QuickCar();
}

class QuickCar extends State<SearchPage> {

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  QuickCar({this.screens});

  final List<Widget> screens;
  static const Tag = "QuickCar";
  final tabs = [ SearchViewPage(),
    Text("hello"), Text("world")];

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
          )


          ],
        onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
        },
      ),
    );
  }



}
