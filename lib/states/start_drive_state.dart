
import 'dart:io';

class StartDriveState {
  final List<File> carImages;
  const StartDriveState({this.carImages});

  StartDriveState copyWith({List<File> carImages}) {
    print("length of car images: ${carImages.length}");
    return StartDriveState(
      carImages: carImages ?? this.carImages,
    );
  }
}