

import 'package:flutter/cupertino.dart';

class FilterSortState extends ChangeNotifier {
  String sortBy = "";

  setSortBy(String s) {
    sortBy = s;
    notifyListeners();
  }
}