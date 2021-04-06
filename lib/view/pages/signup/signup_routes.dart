
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/data_class/quick_car/user_signin.dart';
import 'package:quick_car/models/new_user.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/signup/photo_menu.dart';
import 'package:quick_car/view/pages/signup/signup_form.dart';

import 'credit_card_form.dart';

class SignUpRoutes extends StatefulWidget {
  BuildContext parentContext;
  SignUpRoutes(this.parentContext);
  @override
  _SignUpRoutesState createState() => _SignUpRoutesState();
}

class _SignUpRoutesState extends State<SignUpRoutes> {
  NewUser signUpUser = NewUser();


  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return MaterialApp(
      initialRoute: '/details',
      routes: {
        '/details': (context)=> SignUpForm(signUpUser),
        '/license': (context)=> PhotoMenu(signUpUser),
        '/credit-card': (context) => CreditCard(
          // function of last process of sign in, back to the bottom nav
            ()  {
              userState.setIsLoggedIn(true);
              Navigator.of(widget.parentContext).popUntil(ModalRoute.withName('/'));
            }

        )
      }
    );
  }
}
void finishSignUp() {

}
