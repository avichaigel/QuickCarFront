import 'package:flutter/material.dart';

class FilterParam extends StatefulWidget {
  final IconData icon;
  final String text;

  const FilterParam({
    @required this.text,
    @required this.icon,
  }) : super();

  @override
  _FilterParamState createState() => _FilterParamState();
}

class _FilterParamState extends State<FilterParam> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Container(
            height: 30,
            decoration: BoxDecoration(
              border:Border.all(color: Colors.white) ,
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Row(children: [
              Icon(widget.icon, color: Colors.white,size: 15,),
              Text(
                widget.text,
                style: TextStyle(color: Colors.white, fontSize: 13),
              )
            ])));
  }
}