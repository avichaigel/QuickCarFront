import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
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