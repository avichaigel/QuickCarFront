import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'package:quick_car/view/widgets/date_picker.dart';

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
  bool _isLegalRange = true;
  @override
  void initState() {
    super.initState();
    if (widget.selectedDatePeriod == null) {
      widget.selectedDatePeriod = widget.carDatePeriods[0];
    }
    carDatePeriods = widget.carDatePeriods;
    selectedDatePeriod = widget.selectedDatePeriod;
  }
  void _checkIfLegalSelection(dp.DatePeriod datePeriod) {
    DateTime start = datePeriod.start.add(Duration(seconds: 1));
    DateTime end = datePeriod.end.subtract(Duration(days: 1));
    bool result = false;
    for (int i = 0; i < carDatePeriods.length; i++) {
        if (start.isAfter(carDatePeriods[i].start) && end.isBefore(carDatePeriods[i].end)) {
          result = true;
          break;
        }
    }
    if (result != _isLegalRange) {
      setState(() {
        _isLegalRange = result;
      });
    }

  }
  Table createTable() {
    const double textPadding = 2.0;
    const double textSize = 18;
    List<TableRow> rows = [];
    rows.add( TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(textPadding),
            child: Text("Start date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),),
          ),
          Padding(
            padding: const EdgeInsets.all(textPadding),
            child: Text("End date", style: TextStyle(fontWeight: FontWeight.bold,  fontSize: textSize),),
          ),
        ]
    )
    );
    for (int i = 0; i < carDatePeriods.length; i++) {
      rows.add(TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(textPadding),
              child: Text(DateFormat("yyyy-MM-dd").format(carDatePeriods[i].start),
                  style: TextStyle(fontSize: textSize)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(textPadding),
              child: Text(DateFormat("yyyy-MM-dd").format(carDatePeriods[i].end),
                  style: TextStyle(fontSize: textSize)
              ),
            ),
          ]
      ));
    }
    return Table(
      border: TableBorder.all(),
      children: rows,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Available dates:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: createTable(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select the dates you want to reserve the car", style: TextStyle(fontSize: 16),),
              ),
              Container(
                child: dp.RangePicker(
                  selectedPeriod: selectedDatePeriod,
                  onChanged: (datePeriod) {
                        print(datePeriod.start.toString() + ", " + datePeriod.end.toString() );
                        if (_isLegalRange == false) {
                          _isLegalRange = true;
                        }
                        _checkIfLegalSelection(datePeriod);
                        setState(() {
                          print("in setState");
                          selectedDatePeriod = datePeriod;
                        });

                  },
                  // selectableDayPredicate: _isSelectable,
                  datePickerStyles: styles,
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2023),

                ),
              ),
              Container(
                height: 40,
                child: Visibility(
                  visible: !_isLegalRange,
                  child: Text("Dates picked are not available", style: TextStyle(color: Colors.red, fontSize: 18),
                  ),

                ),
              ),
              ElevatedButton(
                  onPressed:() {
                    if (_isLegalRange) {
                      Navigator.of(context).pop(selectedDatePeriod);
                    }
                  },
                  child: Text("Submit"))
            ],
          ),
        )
      ),
    );
  }
}
