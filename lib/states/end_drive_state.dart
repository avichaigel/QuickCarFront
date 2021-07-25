
import 'dart:io';

class EndDriveState {
  final List<File> carImages;
  final bool passedDamageDetection;
  final double latitude;
  final double longitude;
  const EndDriveState({this.carImages, this.passedDamageDetection, this.latitude, this.longitude});

  EndDriveState copyWith({List<File> carImages, bool passedDamaged, double latitude, double longitude}) {
    return EndDriveState(
      carImages: carImages ?? this.carImages,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      passedDamageDetection: passedDamaged ?? this.passedDamageDetection
    );
  }
}