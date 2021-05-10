
import 'package:flutter/material.dart';


/// This is the stateful widget that the main application instantiates.
class MyDropdownButton extends StatefulWidget {
  const MyDropdownButton({Key key}) : super(key: key);

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyDropdownButtonState extends State<MyDropdownButton> {
  String dropdownValue = 'Days';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      // underline: Container(
      //   height: 2,
      //   color: Colors.deepPurpleAccent,
      // ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Months', 'Days']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
