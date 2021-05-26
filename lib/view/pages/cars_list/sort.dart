import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/states/search_state.dart';

class Sort extends StatefulWidget {
  @override
  _SortState createState() => _SortState();
}

class _SortState extends State<Sort> {
  List<String> _priceOptions = [Strings.SORT_BY_PRICE_CHEAP_TO_EXP, Strings.SORT_BY_PRICE_EXP_TO_CHEAP];

  void setSortBy(SearchState state, String value, bool openTabs) {
    if (value == Strings.SORT_BY_PRICE_CHEAP_TO_EXP) {
      state.setSortedByPrice();
      state.sortedByName = Strings.SORT_BY_PRICE_CHEAP_TO_EXP;
    } else if (value == Strings.SORT_BY_PRICE_EXP_TO_CHEAP) {
      state.setSortedByPrice();
      state.sortedByName = Strings.SORT_BY_PRICE_EXP_TO_CHEAP;
    } else if (value == Strings.SORT_BY_DISTANCE) {
      state.setSortedByDist();
      state.sortedByName = Strings.SORT_BY_DISTANCE;
    }
    if (openTabs == true) {
      state.refresh();
    } else {
      state.loadCars();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
        child: Consumer<SearchState>(
        builder: (context, state, child) {
      return Center(
        child: Column(
            children: [
        Card(
          color: state.sortedByPrice() ? Colors.greenAccent : null,
          child: ListTile(
            onTap:() {
              setSortBy(state, Strings.SORT_BY_PRICE_CHEAP_TO_EXP, true);
            },
            title: Text("Price"),
      )
      ),
      AnimatedOpacity(
      opacity: state.sortedByPrice() ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Visibility(
      visible: state.sortedByPrice(),
      child: RadioButtonGroup(
        picked: state.sortedByPrice() ? state.sortedByName : null,
          labels: _priceOptions,
          onSelected: (String selected) {
            setSortBy(state, selected, false);
            Timer(Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          }

      )  ,
      )
                       ),
      Card(
        color: state.sortedByDist() ? Colors.greenAccent : null,
      child: ListTile(
      onTap:() {
        setSortBy(state, Strings.SORT_BY_DISTANCE, false);
        Timer(Duration(seconds: 1), () {
          // 5s over, navigate to a new page
          Navigator.pop(context);
        });

      },
      title: Text("By distance"),
      )
      ),


      ],
      ),
      );
      },
      )

    ),
    );
}

}

