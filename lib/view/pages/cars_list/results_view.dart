
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/view/widgets/search_widget.dart';

import '../../../data_class/car_data.dart';

import 'package:http/http.dart' as http;
import 'package:quick_car/states/search_state.dart';
import 'package:quick_car/view/pages/cars_list/car_item.dart';
import 'package:quick_car/view/pages/cars_list/search_parameters.dart';
import 'package:quick_car/view/pages/cars_list/sort.dart';


class ResultsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ResultsViewState();
}
class ResultsViewState extends State<ResultsView> {

  List<CarData> cars = [];
  bool _isLoading;
  String query = '';
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build results view");
    return Consumer<SearchState>(
        builder: (context, state, child) {
          _isLoading = state.isLoading();
          // When car list is updating from search text don't take the list from state
          if (!_focusNode.hasFocus)
            cars = state.carsList;
          print("build consumer results view");
          return SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Column(
                    children: [
                      SearchWidget(text: query, hintText: 'Search your car', onChanged: (String s) {
                        setState(() {
                          cars = state.carsList.where((element) => element.brand.startsWith(s)
                              || element.model.startsWith(s)).toList();
                      });},
                      focus: _focusNode,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {
                                print("on pressed");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        SearchParameters()));
                              },
                              child:Row(
                                children: [
                                  Icon(Icons.filter_alt),
                                  Text("Filter")
                                ],
                              )
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Sort())),
                              child: Row(
                                children: [
                                  Icon(Icons.sort),
                                  Text("Sort")
                                ],
                              )
                           ),
                          SizedBox(
                            width: 30,
                          )
                        ],
                      )
                    ],
                  ),
                  body(state)
                ],
              )
          );
        }
      );

}
  Widget body(SearchState state) {
    if (state.isError()) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(state.getErrorMessage(), style: TextStyle(fontSize: 20),),
      );
    }
    if (cars.contains(null) || cars.length < 0 || _isLoading) {
      return SizedBox(
        height: 200,
          child: Center(child: CircularProgressIndicator())
      );
    }
    if (cars.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("No results found", style: TextStyle(fontSize: 20),),
      );
    }
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => state.loadCars(),
        child: ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              return CarItem(cars[index]);
            }) ,
      )
    );

  }

}




