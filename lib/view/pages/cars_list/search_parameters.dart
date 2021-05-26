import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/states/search_state.dart';
import 'package:quick_car/view/widgets/date_picker.dart';

class SearchParameters extends StatefulWidget {
  @override
  SearchParametersState createState() => SearchParametersState();
}

class SearchParametersState extends State<SearchParameters> {
  DatePeriod _datePeriod;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<SearchState>(
        builder: (context, state, child) {
          if (_datePeriod == null) {
            _datePeriod = state.datePeriod();
          }
          return SingleChildScrollView(
            padding: EdgeInsets.only(top: 20,left: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,color: Colors.black87,size: 23,),
                    onPressed: (){
                      state.loadCars();
                      Navigator.pop(context);
                    },),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Distance".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12,),),
                  ),
                ),
                DistanceFilter(),
                PriceFilter(),
                TypeFilter(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Choose the dates".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12,),),
                  ),
                ),
                dp.RangePicker(
                  selectedPeriod: _datePeriod,
                  onChanged: (datePeriod){
                    if (datePeriod.start.difference(DateTime.now()).inDays < 0) {
                      return;
                    }
                    setState(() {
                      _datePeriod = datePeriod;
                    });
                    state.setDatePeriod(datePeriod);
                  },
                  selectableDayPredicate: _isSelectable,
                  datePickerStyles: styles,

                  firstDate: DateTime.now().subtract(Duration(days: 1)),
                  lastDate: DateTime.now().add(Duration(days:  365)),

                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Material(
                    color: Colors.white,
                    elevation: 6,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      //  borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        state.setDefaultValues();
                      },
                      splashColor: Colors.white,
                      hoverColor: Colors.blue,
                      child: Container(
                        // margin: EdgeInsets.symmetric(vertical: 25),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black87),
                        ),
                        child: Text("Default values"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

    )

,
      ),
    );
  }

  bool _isSelectable(DateTime day) {
    return true;
  }

}

class TypeFilter extends StatefulWidget {
  @override
  _TypeFilterState createState() => _TypeFilterState();
}

class _TypeFilterState extends State<TypeFilter> {
  List<bool> typesChecked;
  @override
  Widget build(BuildContext context) {
      return Consumer<SearchState>(
        builder: (context, state, child) {
          if (typesChecked == null) {
            typesChecked = state.typesChecked();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Type".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12,),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: CheckboxListTile(
                    title: Text(CarsGlobals.carTypes[0]),
                    value: state.typesChecked()[0],
                    onChanged: (value){
                      setState(() {
                        state.setTypesChecked(0);
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: CheckboxListTile(
                    title: Text(CarsGlobals.carTypes[1]),
                    value: state.typesChecked()[1],
                    onChanged: (value){
                      setState(() {
                        state.setTypesChecked(1);
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: CheckboxListTile(
                    title: Text(CarsGlobals.carTypes[2]),
                    value: state.typesChecked()[2],
                    onChanged: (value){
                      setState(() {
                        state.setTypesChecked(2);
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: CheckboxListTile(
                    title: Text(CarsGlobals.carTypes[3]),
                    value: state.typesChecked()[3],
                    onChanged: (value){
                      setState(() {
                        state.setTypesChecked(3);
                      });
                    }),
              ),
            ],

          );
        },
    );

  }
}


class PriceFilter extends StatefulWidget {
  @override
  _PriceFilterState createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  RangeValues _range;
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchState>(
      builder: (context, state, child) {
        if (_range == null) {
          _range = state.priceRange();
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Price per day".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12,),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                elevation: 5,
                child: Container(
                  // margin: EdgeInsets.symmetric(vertical: 25),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black87),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Prices range",style: TextStyle(fontSize: 15),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RangeSlider(
                            onChanged: (RangeValues newRange){
                              setState(() {
                                _range = newRange;
                              });
                              state.setPriceRange(newRange);
                            },
                            values: _range,
                            min: 0.0,
                            max: 1000.0,
                            divisions: 50,
                            labels: RangeLabels(_range.start.toInt().toString(),
                                _range.end.toInt().toString()),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                  width: 80.0,
                                  height: 20.0,
                                  child: Text(
                                      "Min: ${_range.start.toInt().toString()}",
                                      style: TextStyle(color: Colors.grey,fontSize: 12,)
                                  )
                              ),
                              SizedBox(
                                  width: 80.0,
                                  height: 20.0,
                                  child: Text(
                                      "Max: ${_range.end.toInt().toString()}",
                                      style: TextStyle(color: Colors.grey,fontSize: 12,)
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

  }
}



class DistanceFilter extends StatefulWidget {
  DistanceFilter({Key key}) : super(key: key);
  @override
  _DistanceFilterState createState() => _DistanceFilterState();
}

class _DistanceFilterState extends State<DistanceFilter> {

  double _value;

  Text distText() {
    if (_value == CarsGlobals.MAX_DISTANCE) {
      return Text("No limitation");
    } else {
      return Text("${_value.toInt().toString()} km");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchState>(
      builder: (context, state, chile) {
        if (_value == null) {
          _value = state.distanceFilter() != null ?  state.distanceFilter(): CarsGlobals.MAX_DISTANCE;
        }
        return Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Slider(
                      value: _value,
                      min: 0.0,
                      max: CarsGlobals.MAX_DISTANCE,
                      onChanged: (value){
                        setState(() {
                          _value = value;
                        });
                        if (_value == CarsGlobals.MAX_DISTANCE) {
                          state.setDistFilter(null);
                        } else {
                          state.setDistFilter(_value);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: distText()
                    )
                  ],
                )

            ),

          ],
        );
      },
    ) ;

  }
}



