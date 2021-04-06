
import 'package:flutter/material.dart';

class PlayGroundPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PalyGround();

}

class PalyGround extends State<PlayGroundPage> {
  final names = ["ori", "shay", "shiri"];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: names.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(names[index], style: TextStyle(fontSize: 30),),
                        Text("hello")
                      ],
                    ),
                  )
                );
              },

            )
          )
        ],
      )
    );
  }

}