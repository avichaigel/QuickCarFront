import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';

class Camera extends StatefulWidget {
  final Function(String) callback;
  Camera(this.callback);
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController _control;
  Future<void> _future;
  double sizeWidth;
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  void _initApp() async
  {
    final firstCam = cameras.first;

    _control = CameraController(
      firstCam,
      ResolutionPreset.high,
    );

    _future = _control.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _control.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
         child: FutureBuilder<void>(
        future: _future,
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.done)
            return Container(
              width: sizeWidth,
              height: sizeWidth,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      width: sizeWidth,
                      height: sizeWidth,
                      child: CameraPreview(_control), // this is my CameraPreview
                    ),
                  ),
                ),
              ),
            );
            else {
            print("connection state: " + snapshot.connectionState.toString());
            return Center(child: CircularProgressIndicator(),);
          }

        },
      )
      ),
      floatingActionButton: FloatingActionButton(

        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _future;
            await _control.takePicture().then((value) async => widget.callback(await _resizePhoto(value.path)));
            Navigator.pop(context);
          } catch (e) {
            print(e);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }


}
Future<String> _resizePhoto(String filePath) async {
  ImageProperties properties =
  await FlutterNativeImage.getImageProperties(filePath);

  int width = properties.width;
  var offset = (properties.height - properties.width) / 2;

  File croppedFile = await FlutterNativeImage.cropImage(
      filePath, 0, offset.round(), width, width);

  return croppedFile.path;
}