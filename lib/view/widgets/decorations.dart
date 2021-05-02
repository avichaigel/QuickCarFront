
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration customDecoration ()
{
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        offset: Offset(0,2),
        color: Colors.grey[300],
        blurRadius: 5,
      )],
  );
}
