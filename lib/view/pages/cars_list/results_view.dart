
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/api/quick_car_api/cars_api.dart';
import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';

import 'package:http/http.dart' as http;
import 'package:quick_car/states/filter_sort_state.dart';
import 'package:quick_car/view/pages/cars_list/car_Item.dart';
import 'package:quick_car/view/pages/cars_list/sort.dart';


class ResultsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ResultsViewState();
}
class ResultsViewState extends State<ResultsView> {
  //SHOULD BE HERE:
  // final Future<List<CarData>> carsList = Globals.carsListApi.getCars();

  @override
Widget build(BuildContext context) {
    final Future<List<CarData>> carsList = Globals.carsListApi.getCars();

    return Consumer<FilterSortState>(
        builder: (context, params, child) {
          return   SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => SearchParameters()),
                    //   );
                    // },
                    splashColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black87),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1,vertical: 10),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.search),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Search your car",style:TextStyle(fontSize: 13,color: Colors.black54),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Sort())),
                                  child: Icon(Icons.sort)

                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text("Sort by: " + params.sortBy ),
                  Expanded (
                      child: SizedBox(
                          height: 100.0,
                          child: FutureBuilder<List<CarData>>(
                              future: carsList,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("len: " + snapshot.data.length.toString());
                                  return ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        var car = snapshot.data[index];
                                        return CarItemView(car);
                                      });
                                } else {
                                  return Center(child: CircularProgressIndicator()); }
                              })
                      )
                  )
                ],
              )
          );
        }
      );

}

}



