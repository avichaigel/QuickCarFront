// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

UserSignIn signInUserFromJson(String str) => UserSignIn.fromJson(json.decode(str));

String signInUserToJson(UserSignIn data) => json.encode(data.toJson());

class UserSignIn {
  UserSignIn({
    this.email,
    this.password,
  });

  String email;
  String password;

  factory UserSignIn.fromJson(Map<String, dynamic> json) => UserSignIn(
    email: json["username"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "username": email,
    "password": password,
  };
}
