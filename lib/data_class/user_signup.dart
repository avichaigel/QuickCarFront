
import 'dart:convert';

import 'package:quick_car/models/mycurrency.dart';

UserSignUp userSignUpFromJson(String str) => UserSignUp.fromJson(json.decode(str));

String userSignUpToJson(UserSignUp data) => json.encode(data.toJson());

class UserSignUp {
  UserSignUp({
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.currency,
  });

  int id;
  String username;
  String firstName;
  String lastName;
  String email;
  String password;
  MyCurrency currency;

  factory UserSignUp.fromJson(Map<String, dynamic> json) => UserSignUp(
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    password: json["password"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "password": password,
    "currency": currency,
  };
}
