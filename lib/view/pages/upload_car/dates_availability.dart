import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/view/widgets/date_picker.dart';

class DatesAvailability extends StatefulWidget {
  int carId;
  DatesAvailability(this.carId);
  @override
  _DatesAvailabilityState createState() => _DatesAvailabilityState();
}

class _DatesAvailabilityState extends State<DatesAvailability> {
  DatePeriod _currDatePeriod = DatePeriod(DateTime.now().add(Duration(days: 4)), DateTime.now());
  int _number;
  String _period = "Months";
  bool _noAvailability = false;
  bool _isLoading = false;
  List<dp.DatePeriod> _availabilityDates;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _availabilityDates = [];

  }

  void onChangeDate(datePeriod) {
  setState(() {
  _currDatePeriod = datePeriod;
  });

  }

  void onChangedTextField(String value) {
    DateTime date = DateTime.now();
    DateTime endDate = DateTime.now();
    _number = int.parse(value);
      if (_period == "Months") {
        int years = ((_number + endDate.month) / 12).floor();
        endDate = DateTime(endDate.year + years, (endDate.month + _number) % 12, endDate.day);
        print("end date: " + endDate.toString());
        setState(() {
          onChangeDate(DatePeriod(DateTime.now(), endDate.add(date.difference(date)))) ;
        });
      } else if (_period == "Days") {
        setState(() {
          onChangeDate(DatePeriod(DateTime.now(), DateTime.now().add(Duration(days: _number)))) ;
        });

      }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Availability"),
      ),
      body: SingleChildScrollView(
        // child: Center(

          child: !_isLoading ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select the period the car is available"),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
              children: [
              Text(
              "Available for the next",
                style: TextStyle(
                    fontSize: 20
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      width: 50,
                      child: TextField(
                        onChanged: onChangedTextField,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: DropdownButton<String>(
                      value: _period,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String newValue) {
                        setState(() {
                          _period = newValue;
                        });
                      },
                      items: <String>['Months', 'Days']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                ],
              ),
              Container(
                child: dp.RangePicker(
                  selectedPeriod: _currDatePeriod,
                  onChanged: onChangeDate,
                  // selectableDayPredicate: _isSelectable,
                  datePickerStyles: styles,
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2023),

                ),
              ),

              Text("Start date: " + DateFormat("yyyy-MM-dd").format(_currDatePeriod.start)  +
                  "\nEnd date: " + DateFormat("yyyy-MM-dd").format(_currDatePeriod.end),
                style: TextStyle(fontSize: 18),

              ),
            ],
          ),
              SizedBox(
                height: 15,
              ),
              TextButton(
                  onPressed: () {
                    if (_noAvailability == true) {
                      return;
                    }
                    setState(() {
                      _availabilityDates.add(_currDatePeriod);
                    });
                  },
                  child: Text("Add")
              ),

              Padding(
                padding: const EdgeInsets.all(4),
                child: createTable()
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: CheckboxListTile(
                    title: Text("Car will not be available"),
                    value: _noAvailability,
                    onChanged: (value){
                      setState(() {
                        _noAvailability = value;
                        if (_noAvailability == true) {
                          _availabilityDates = [];
                        }
                      });
                    }),
              ),
              TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    if (_noAvailability == true) {
                      Navigator.pop(context);
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });
                    await Globals.carsApi.postCarDates(widget.carId, _availabilityDates);
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Submit")
              )
            ],
          ) : Center(child:Center(child: CircularProgressIndicator())),
        // ),
      ) ,
    );

  }

  Table createTable() {
    List<TableRow> rows = [];
    rows.add( TableRow(
      children: [
      Text("Start date", style: TextStyle(fontWeight: FontWeight.bold),),
      Text("End date", style: TextStyle(fontWeight: FontWeight.bold),),
    ]
    )
    );
    for (int i = 0; i < _availabilityDates.length; i++) {
      rows.add(TableRow(
        children: [
          Text(DateFormat("yyyy-MM-dd").format(_availabilityDates[i].start)),
          Text(DateFormat("yyyy-MM-dd").format(_availabilityDates[i].end)),
        ]
      ));
    }
    return Table(
      border: TableBorder.all(),
      children: rows,
    );
  }
}
