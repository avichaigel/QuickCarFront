// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'dart:io';

UserSignIn signInUserFromJson(String str) => UserSignIn.fromJson(json.decode(str));

String signInUserToJson(UserSignIn data) => json.encode(data.toJson());

class UserSignIn {
  UserSignIn({
    this.email,
    this.password,
  });
  int id;
  String email;
  String password;
  String firstName;
  String lastName;
  File carLicense;
  String token;

  UserSignIn.fromUserSignIn({
    this.id,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.carLicense
  });

  factory UserSignIn.fromJson(Map<String, dynamic> json) {
    print("json::"+json.toString());
    return UserSignIn.fromUserSignIn(
      id: json["id"],
      email: json["username"],
      password: json["password"],
      firstName: json["first_name"],
      lastName: json["last_name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": email,
    "password": password,
  };
}
