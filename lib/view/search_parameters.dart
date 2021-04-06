
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/models/filter_data.dart';
import 'package:quick_car/view/results_view.dart';


class SearchParameters extends StatefulWidget {
  @override
  SearchParametersState createState() => SearchParametersState();
}

class SearchParametersState extends State<SearchParameters> {

  var _filterData = FilterData();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _filterParams = _filterData.map;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20,left: 10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.black87,size: 23,),
                  onPressed: (){
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Slider(
                      value: _filterParams["distance"],
                      min: 0.0,
                      max: 100.0,
                      onChanged: (value){
                        setState(() {
                          _filterData.distance = value;
                        });
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text("${_filterData.distance.toInt().toString()} km"),
                  )
                  ],
                )

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Type".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12,),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: CheckboxListTile(
                    title: Text("Family"),
                    value: _filterParams["family"],
                    onChanged: (value){
                      setState(() {
                        _filterData.family=value;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: CheckboxListTile(
                    title: Text("Small"),
                    value: _filterParams["small"],
                    onChanged: (value){
                      setState(() {
                        _filterData.small=value;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Price per day".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12,),),
                ),
              ),
              /** **/
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
                                    _filterData.pricesRange = newRange;
                                  });
                                }, values: _filterParams["pricesRange"],
                                min: 0.0,
                                max: 3000.0,
                                divisions: 50,
                                labels: RangeLabels(_filterData.pricesRange.start.toInt().toString(),
                                    _filterData.pricesRange.end.toInt().toString()),
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
                                          "Min: ${_filterData.pricesRange.start.toInt().toString()}",
                                          style: TextStyle(color: Colors.grey,fontSize: 12,)
                                      )
                                  ),
                                  SizedBox(
                                      width: 80.0,
                                      height: 20.0,
                                      child: Text(
                                          "Max: ${_filterData.pricesRange.end.toInt().toString()}",
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
              /** **/
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Choose the dates".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12,),),
                ),
              ),
              dp.RangePicker(
                selectedPeriod: _filterParams["period"],
                onChanged: (datePeriod){
                  if (datePeriod.start.difference(DateTime.now()).inDays < 0) {
                    return;
                  }
                  setState(() {
                    _filterData.period = datePeriod;
                  });

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
                      Navigator.of(context).pop();
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text("Filtrer"),
                          Icon(Icons.apps)
                        ],
                      ),
                    ),
                  ),
                ),
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
                      setState(() {
                        _filterData.setDefaultValues();
                      });
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(2.5),
                                child: Text("Default values"),
                              )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSelectable(DateTime day) {
    return true;
  }
  dp.DatePickerRangeStyles styles = dp.DatePickerRangeStyles(
    selectedPeriodLastDecoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0))),
    selectedPeriodStartDecoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          bottomLeft: Radius.circular(24.0)
      ),
    ),
    selectedPeriodMiddleDecoration: BoxDecoration(
        color: Colors.blue, shape: BoxShape.rectangle),
    nextIcon: const Icon(Icons.arrow_right),
    prevIcon: const Icon(Icons.arrow_left),
    // dayHeaderStyleBuilder: _dayHeaderStyleBuilder
  );
}
