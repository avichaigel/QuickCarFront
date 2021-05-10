import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/states/filter_sort_state.dart';

class Sort extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<FilterSortState>(
          builder: (context, params, child) {
            return Center(
              child: Column(
                children: [
                  Card(
                      child: ListTile(
                        onTap:() {
                          try{
                            params.setSortBy("cdsadsdsadsads");
                            Navigator.pop(context);
                          } catch(e) {
                            print("error:::::::: " + e);
                          }

                        },
                        title: Text("By price"),
                      )
                  ),
                  Card(
                      child: ListTile(
                        onTap:()=> Navigator.pop(context),
                        title: Text("By location"),
                      )
                  )

                ],
              ),
            );
          },
        )

      ),
    );
  }
}
