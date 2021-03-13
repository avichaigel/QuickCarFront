
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:quick_car/api/api.dart';
import 'package:quick_car/models/car_model.dart';

import 'car_listview/car_listview.dart';

class SearchViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchView();
}

class SearchView extends State<SearchViewPage> {

  FloatingSearchBarController controller;
  Future<CarMetadata> _carsList;


  @override
  void initState() {
    _carsList = API().getCars();
    controller = FloatingSearchBarController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      builder: (context, transition) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Text("search filters"),
        ); },
      controller: controller,
      body:  Container (
        child: FutureBuilder<CarMetadata>(future: _carsList, builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("has data");
            final fsb = FloatingSearchBar.of(context);
            return ListView.builder(
                padding: EdgeInsets.only(top: fsb.height + fsb.margins.vertical),
                itemCount: snapshot.data.cars.length,
                itemBuilder: (context, index) {
                  var car = snapshot.data.cars[index];
                  return CarSearchView(myCar: car,);
                });
          } else {
            return Center(child: CircularProgressIndicator()); }
        },),
      ),
      transition: CircularFloatingSearchBarTransition(),
      physics: BouncingScrollPhysics(),
      title: Text(
        'QuickCar',
        style: Theme.of(context).textTheme.headline6,
      ),
    );

  }

}