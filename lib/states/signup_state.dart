import 'package:flutter/cupertino.dart';
import 'package:quick_car/api/quick_car_api/sign_up.dart';
import 'package:stripe_payment/stripe_payment.dart';

class SignUpState {
  final SignUpApi api;
  final bool formCompleted;
  final String picture;
  final bool licenseCompleted;
  final CreditCard creditCard;

  const SignUpState({this.api, this.formCompleted, this.picture, this.licenseCompleted, this.creditCard});

  SignUpState copyWith({bool formCompleted, String picture, bool licenseCompleted,
    CreditCard creditCard}) {
    return SignUpState(
      formCompleted: formCompleted ?? this.formCompleted,
      picture: picture ?? this.picture,
      licenseCompleted: licenseCompleted ?? this.licenseCompleted,
      creditCard: creditCard ?? this.creditCard,
    );
  }
}