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
Widget showAlert(String message, Function onPressed) {
  if (message != null) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Container(
        color: Colors.amberAccent,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                message,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  onPressed();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}