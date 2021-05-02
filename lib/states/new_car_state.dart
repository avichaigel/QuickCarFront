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
  final List<String> photos;

  // 4
  final DatePeriod availability;

  // 5
  final int pricePerDay;
  const NewCarState({this.latitude, this.longitude, this.companyName, this.model, this.kilometers, this.manufYear,
    this.type, this.photos, this.availability, this.pricePerDay});


  NewCarState copywith({double latitude, double longitude, String companyName, String model, int kilometers,
    String manufYear, String type, List<String> photos, DatePeriod availabilty, int pricePerDay}) {
    return NewCarState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      companyName: companyName ?? this.companyName,
      model: model ?? this.model,
      kilometers: kilometers ?? this.kilometers,
      manufYear: manufYear ?? this.manufYear,
      type: type ?? this.type,
      photos: photos ?? this.photos,
        availability: availabilty ?? this.availability,
      pricePerDay: pricePerDay ?? this.pricePerDay

    );
  }
}