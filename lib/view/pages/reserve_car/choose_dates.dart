

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class ChooseDates extends StatefulWidget {
  List<DatePeriod> carDatePeriods;
  DatePeriod selectedDatePeriod;
  ChooseDates({this.carDatePeriods, this.selectedDatePeriod, Key key}): super(key: key);
  @override
  ChooseDatesState createState() => ChooseDatesState();
}

class ChooseDatesState extends State<ChooseDates> {
  List<DatePeriod> carDatePeriods;
  DatePeriod selectedDatePeriod;
  @override
  void initState() {
    super.initState();
    if (widget.selectedDatePeriod == null) {
      widget.selectedDatePeriod = widget.carDatePeriods[0];
    }
    carDatePeriods = widget.carDatePeriods;
    selectedDatePeriod = widget.selectedDatePeriod;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child:         Column(
            children: [
              Text(selectedDatePeriod.start.toString()),
              TextButton(
                  onPressed:()=> Navigator.of(context).pop(selectedDatePeriod),
                  child: Text("back"))
            ],
          ),
        )
      ),
    );
  }
}
