import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


Widget image(String imagePath) {
  return Container(
    width: 400,
    height: 400,
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

Widget imageButtons(Function onCameraPressed, Function onGalleryPressed) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      TextButton.icon(
          onPressed: () => onCameraPressed(ImageSource.camera),
          label: Text("Camera"),
          icon: Icon(Icons.camera_alt),

      ),
      TextButton.icon(
          onPressed: () => onGalleryPressed(ImageSource.gallery),
          icon: Icon(Icons.image),
          label: Text("Gallery"))
    ],
  );
}