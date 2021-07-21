import 'dart:io';

import 'package:quick_car/constants/strings.dart';

class UserSignIn {
  UserSignIn({
    this.email,
    this.password,
  });
  int id;
  int userProfileId;
  String email;
  String password;
  String firstName;
  String lastName;
  File carLicense;
  String token;
  String currency;

  UserSignIn.fromUserSignIn({
    this.id,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.carLicense,
    this.currency
  });

  factory UserSignIn.fromJson(Map<String, dynamic> json) {
    print("json:"+json.toString());
    return UserSignIn.fromUserSignIn(
      id: json["id"],
      email: json["username"],
      password: json["password"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      currency: json.containsKey("currency") ? json["currency"] : Strings.USD,
    );
  }
  setDetailsFromUserProfile(Map<String, dynamic> json) {
    userProfileId = json["user"];
    if (json["license"] != null)
      carLicense = File(json["license"]);
  }

  Map<String, dynamic> toJson() => {
    "username": email,
    "password": password,
  };
}
