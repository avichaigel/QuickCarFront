import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



Widget imageContainer(File image) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, ),

    ),
      child: image == null ?
        emptyImage() :
        FittedBox(
          child: Image(
              image: FileImage(image),
            fit: BoxFit.fill,
            ),
        ),
    );
}

Widget emptyImage() {
  return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.add_a_photo),
        ),
      ]
  );
}

