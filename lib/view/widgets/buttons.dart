
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget nextButton({@required Function onPressed}) {
  return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: () {
        onPressed();
      },
    child: Text('Next', style: TextStyle(color: Colors.white, fontSize: 16),
    )
  );
}

Widget skipButton({@required Function onPressed}) {
  return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: () {
        onPressed();
      },
      child: Text('Skip', style: TextStyle(color: Colors.white, fontSize: 16),
      )
  );
}