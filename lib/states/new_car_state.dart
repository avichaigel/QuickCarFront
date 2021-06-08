import 'dart:io';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class NewCarState {
  // 1
  final double latitude;
  final double longitude;

  // 2
  final String companyName;
  final String model;
  final int kilometers;
  final String manufYear;
  final String type;

  // 3
  final List<File> images;

  // 4
  final int pricePerDay;

  const NewCarState({this.latitude, this.longitude, this.companyName, this.model, this.kilometers, this.manufYear,
    this.type, this.images, this.pricePerDay});

  NewCarState copywith({double latitude, double longitude, String companyName, String model, int kilometers,
    String manufYear, String type, List<File> images, int pricePerDay}) {
    return NewCarState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      companyName: companyName ?? this.companyName,
      model: model ?? this.model,
      kilometers: kilometers ?? this.kilometers,
      manufYear: manufYear ?? this.manufYear,
      type: type ?? this.type,
      images: images ?? this.images,
      pricePerDay: pricePerDay ?? this.pricePerDay

    );
  }
}