import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/view/widgets/filter_param.dart';
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
  bool _filterByName = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }


  Widget getSortDisplay(SearchState state) {
    return Container(
        height: 40,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            // color: Colors.grey.shade700
            color: Colors.blue
        ),
        child: GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Sort())),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Icon(
                Icons.sort,
                color: Colors.white,
              ),
              FilterParam(
                text:
                    "Sort by - ${state.sortedByDist() ? "Distance" : "Price: ${state.sortedByName == Strings.SORT_BY_PRICE_CHEAP_TO_EXP ? "low to high" : "high to low"}"}",
                icon: state.sortedByDist()
                    ? Icons.location_on
                    : Icons.attach_money,
              ),
            ])));
  }

  Widget getFiltersDisplay(SearchState state) {
    return Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            // color: Colors.grey.shade700
            color: Colors.blue
        ),
        child: GestureDetector(
            onTap: () {
              print("on pressed");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchParameters()));
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.filter_alt,
                    color: Colors.white,
                  ),
                  FilterParam(
                    text: state.distanceFilter() == null
                        ? "max"
                        : "${state.distanceFilter().toInt()} km",
                    icon: Icons.location_on,
                  ),
                  FilterParam(
                    text:
                        "${state.priceRange().start.toInt()}-${state.priceRange().end.toInt()}",
                    icon: Icons.attach_money,
                  ),
                  FilterParam(
                    text: state
                        .getTypesChecked()
                        .toString()
                        .replaceFirst("carTypes.", ""),
                    icon: Icons.directions_car_outlined,
                  ),
                  FilterParam(
                    text:
                        "${state.datePeriod().start.day}/${state.datePeriod().start.month}-${state.datePeriod().end.day}/${state.datePeriod().end.month}",
                    icon: Icons.date_range,
                  ),
                  SizedBox(width: 10)
                ])));
  }

  @override
  Widget build(BuildContext context) {
    print("build results view");
    return Consumer<SearchState>(builder: (context, state, child) {
      _isLoading = state.isLoading();
      if (!_focusNode.hasFocus) cars = state.carsList;
      print("build consumer results view");
      return SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          // Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchWidget(
                text: query,
                hintText: 'Search your car',
                onChanged: (String s) {
                  setState(() {
                    cars = state.carsList
                        .where((element) =>
                            element.brand.startsWith(s) ||
                            element.model.startsWith(s))
                        .toList();
                  });
                },
                focus: _focusNode,
              ),
              Padding(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getFiltersDisplay(state),
                      SizedBox(height: 5),
                      getSortDisplay(state),
                    ]),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              )
            ],
          ),
          // ),
          // InkWell(
          //   borderRadius: BorderRadius.circular(20),
          //   splashColor: Colors.white,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20),
          //       border: Border.all(color: Colors.black87),
          //     ),
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 1,vertical: 10),
          //       child: SearchWidget(text: query, hintText: 'Search your car', onChanged: (String s)=>print("chamge"),),
          //       // child: Row(
          //       //   children: <Widget>[
          //       //     SizedBox(
          //       //       width: 10,
          //       //     ),
          //       //     // TODO: search with search icon, filter by car company
          //       //     Icon(Icons.search),
          //       //     SizedBox(
          //       //       width: 10,
          //       //     ),
          //       //     Text("Search your car",style:TextStyle(fontSize: 13,color: Colors.black54),
          //       //       overflow: TextOverflow.ellipsis,
          //       //     ),
          //       //     Spacer(),
          //       //     Padding(
          //       //       padding: const EdgeInsets.only(left: 12.0, right: 12),
          //       //       child: GestureDetector(
          //       //         onTap: () {
          //       //           print("on pressed");
          //       //           Navigator.push(
          //       //               context,
          //       //               MaterialPageRoute(builder: (context) =>
          //       //                   SearchParameters()));
          //       //         },
          //       //         child:Icon(Icons.filter_alt)
          //       //       ),
          //       //     ),
          //       //     Padding(
          //       //       padding: const EdgeInsets.only(right: 8.0),
          //       //       child: GestureDetector(
          //       //           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Sort())),
          //       //           child: Icon(Icons.sort)
          //       //
          //       //       ),
          //       //     )
          //       //   ],
          //       // ),
          //     ),
          //   ),
          // ),
          body(state)
        ],
      ));
    });
  }

  Widget body(SearchState state) {
    if (state.isError()) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          state.getErrorMessage(),
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    if (cars.contains(null) || cars.length < 0 || _isLoading) {
      return SizedBox(
          height: 200, child: Center(child: CircularProgressIndicator()));
    }
    if (cars.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "No results found",
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async => state.loadCars(),
      child: ListView.builder(
          itemCount: cars.length,
          itemBuilder: (context, index) {
            return CarItem(cars[index]);
          }),
    ));
  }
}
