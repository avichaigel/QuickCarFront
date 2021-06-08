
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data_class/user_signin.dart';
import 'package:quick_car/states/signup_state.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/signup/upload_car_license.dart';
import 'package:quick_car/view/pages/signup/signup_form.dart';

import 'upload_credit_card.dart';


List<Page> onGenerateSignUpPages(SignUpState signupState, List<Page> pages) {
  return [
    MaterialPage<void>(child: SignUpForm()),
    if (signupState.formCompleted == true) MaterialPage<void>(child: UploadCarLicense()),
    if (signupState.licenseCompleted == true) MaterialPage<void>(child: UploadCreditCard(asb: true,)),
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

