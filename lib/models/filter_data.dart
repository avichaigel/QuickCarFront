// import 'package:flutter/material.dart';
// import 'package:flutter_date_pickers/flutter_date_pickers.dart';
//
// class FilterData {
//   RangeValues pricesRange;
//   double distance;
//   bool family;
//   bool small;
//   DatePeriod period;
//
//   FilterData._() {
//    setDefaultValues();
//   }
//   static final FilterData _instance = FilterData._();
//   factory FilterData() {
//     return _instance;
//   }
//
//   setDefaultValues() {
//     period = DatePeriod(DateTime.now().add(Duration(days: 4)), DateTime.now().subtract(Duration(days: 4)));
//     pricesRange = RangeValues(30, 200);
//     distance = 10;
//     family = true;
//     small = true;
//   }
//
//
//   Map<String, dynamic> get map {
//     return {
//       "pricesRange": pricesRange,
//       "distance": distance,
//       "family": family,
//       "small": small,
//       "period": period,
//     };
//   }
// }