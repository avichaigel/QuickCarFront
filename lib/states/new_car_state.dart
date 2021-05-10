import 'dart:io';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class NewCarState {
  // 1
  //longitude latitude
  final double latitude;
  final double longitude;

  // 2
  final String companyName;
  final String model;
  final int kilometers;
  final String manufYear;
  final String type;

  // 3
  final bool imagesUploaded;
  final File image1;
  final List<File> images;

  // 4
  final DatePeriod availability;
  final bool availabilityDone;

  // 5
  final int pricePerDay;

  const NewCarState({this.latitude, this.longitude, this.companyName, this.model, this.kilometers, this.manufYear,
    this.type, this.imagesUploaded, this.image1, this.images, this.availability, this.availabilityDone, this.pricePerDay});

  NewCarState copywith({double latitude, double longitude, String companyName, String model, int kilometers,
    String manufYear, String type, bool imagesUploaded, List<File> images, File image1, DatePeriod availability,
    bool availabilityDone, int pricePerDay}) {
    return NewCarState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      companyName: companyName ?? this.companyName,
      model: model ?? this.model,
      kilometers: kilometers ?? this.kilometers,
      manufYear: manufYear ?? this.manufYear,
      type: type ?? this.type,
      imagesUploaded: imagesUploaded ?? this.imagesUploaded,
      images: images ?? this.images,
      image1: image1 ?? this.image1,
      availability: availability ?? this.availability,
      availabilityDone: availabilityDone ?? this.availabilityDone,
      pricePerDay: pricePerDay ?? this.pricePerDay

    );
  }
}