
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/data_class/quick_car/user_signin.dart';
import 'package:quick_car/states/signup_state.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/signup/photo_menu.dart';
import 'package:quick_car/view/pages/signup/signup_form.dart';

import 'credit_card_form.dart';


List<Page> onGenerateSignUpPages(SignUpState signupState, List<Page> pages) {
  return [
    MaterialPage<void>(child: SignUpForm()),
    if (signupState.formCompleted == true) MaterialPage<void>(child: PhotoMenu()),
    if (signupState.licenseCompleted == true) MaterialPage<void>(child: CreditCard()),
  ];
}
class SignupFlow extends StatelessWidget  {

  @override
  Widget build(BuildContext context) {

    return FlowBuilder(
        state: SignUpState(),
        onGeneratePages: onGenerateSignUpPages);

  }
}

