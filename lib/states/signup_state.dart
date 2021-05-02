import 'package:flutter/cupertino.dart';
import 'package:quick_car/api/quick_car_api/sign_up.dart';

class SignUpState {
  final SignUpApi api;
  final bool formCompleted;
  final String picture;
  final bool licenseCompleted;
  final bool creditCardCompleted;

  const SignUpState({this.api, this.formCompleted, this.picture, this.licenseCompleted, this.creditCardCompleted});

  SignUpState copyWith({bool formCompleted, String picture, bool licenseCompleted, bool creditCardCompleted}) {
    return SignUpState(
      formCompleted: formCompleted ?? this.formCompleted,
      picture: picture ?? this.picture,
      licenseCompleted: licenseCompleted ?? this.licenseCompleted,
      creditCardCompleted: creditCardCompleted ?? this.creditCardCompleted,
    );
  }
}