import 'package:flutter/material.dart';

void myShowDialog (BuildContext context, String title, String body) {
  print("in show dialog");
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: new Text(title),
      content: new Text(body),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        ElevatedButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  });
}