import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/view/widgets/buttons.dart';
import 'package:quick_car/view/widgets/date_picker.dart';

class DatesAvailability extends StatefulWidget {
  @override
  _DatesAvailabilityState createState() => _DatesAvailabilityState();
}

class _DatesAvailabilityState extends State<DatesAvailability> {
  DatePeriod _datePeriod = DatePeriod(DateTime.now().add(Duration(days: 4)), DateTime.now());
  int _number;
  String _period = "Months";
  bool _noLimit = false;

  void onChangeDate(datePeriod) {
  setState(() {
  _datePeriod = datePeriod;
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
  void _continuePressed() {
    context
        .flow<NewCarState>()
        .update((carState) => carState.copywith(availability: _datePeriod, availabilityDone: true));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Availability"),
      ),
      body: SingleChildScrollView(
        // child: Center(

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select the period the car is available"),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: CheckboxListTile(
                    title: Text("No dates limitation"),
                    value: _noLimit,
                    onChanged: (value){
                      setState(() {
                        _noLimit = value;
                      });
                    }),
              ),
              AnimatedOpacity(
                  opacity: _noLimit ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 500),
                  child:  Column(
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
                          border: OutlineInputBorder(),
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
                  selectedPeriod: _datePeriod,
                  onChanged: onChangeDate,
                  // selectableDayPredicate: _isSelectable,
                  datePickerStyles: styles,
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2023),

                ),
              ),

              Text("Start date: " + DateFormat("yyyy-MM-dd").format(_datePeriod.start)  +
                  "\nEnd date: " + DateFormat("yyyy-MM-dd").format(_datePeriod.end),
                style: TextStyle(fontSize: 20),

              ),
            ],
          )
              ),
              SizedBox(
                height: 15,
              ),

              nextButton(onPressed: () => {
                _continuePressed()
              }),
            ],
          ),
        // ),
      ) ,
    );

  }
}
