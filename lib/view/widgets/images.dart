import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget newImage(Image image) {
  return Container(
    width: 300,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
    ),
    child: image == null ? Image(
      image: AssetImage("assets/upload-image.png"),
    ) : FittedBox(
      child: image,
      fit: BoxFit.fill,
    ),
  );
}


Widget image(String imagePath) {
  return Container(
    width: 300,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
    ),
    child: imagePath == null ? Image(
      image: AssetImage("assets/upload-image.png"),
    ) : FittedBox(
      child: Image.file(File(imagePath)),
      fit: BoxFit.fill,
    ),
  );
}

