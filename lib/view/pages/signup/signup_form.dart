import 'package:currency_picker/currency_picker.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/services/email_validate.dart';
import 'package:quick_car/view/widgets/currency_picker.dart';
import 'package:quick_car/view/widgets/messages.dart';
import '../../../data_class/user_signup.dart';
import 'package:quick_car/states/signup_state.dart';
import 'package:quick_car/view/widgets/buttons.dart';
import 'package:quick_car/view/widgets/country_list_pick.dart';
import 'package:quick_car/view/widgets/decorations.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _currencyCode = Strings.USD;

  bool _isLoading = false;
  bool _isErr = false;
  String _errMsg = '';


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();

  Widget _buildFirstName() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'First Name'),
      maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'First name is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _firstName = value;
      },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Last Name'),
      maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Last name is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _lastName = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }
        return null;
      },
      onSaved: (String value) async {
        print("onSaved called in buildEmail");
        _email = value;
      },
    );
  }
  Widget _buildPassword() {
    int minPwdLen = 8;
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: 'Password'),
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        _password = value;
        if (value.isEmpty) {
          return 'Password is Required';
        }
        if (value.length < minPwdLen) {
          return "Password must be at least ${minPwdLen} characters long";
        }

        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  Widget _buildPasswordVaildation() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: 'Confirm Password'),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }
        if (value != _passwordController.text) {
          return 'Password must be same as above';
        }

        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }


  void _continuePressed() {
    setState(() {
      _isLoading = true;
    });


    UserSignUp nu = UserSignUp();
    nu.username = _email;
    nu.firstName = _firstName;
    nu.lastName = _lastName;
    nu.email = _email;
    nu.password = _password;
    nu.currencyCode = _currencyCode;

    CarsGlobals.signUpApi.signUpNewUser(nu).then((value) {
      print(value);
      context
          .flow<SignUpState>()
          .update((signUpState) => signUpState.copyWith(id: value.id, formCompleted: true));})
        .onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
        _isErr = true;
        _errMsg = error.toString();
      });
    });

  }

  onChooseCurrency(Currency currency){
    _currencyCode = currency.code;
    print("currency code: $_currencyCode");
  }
  _showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true)
            .pop(true); // dismisses only the dialog and returns true
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("The email you provided does not exist"),
      content: Text("Please provide a real email address"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign up")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(8.0),
              decoration: customDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildFirstName(),
                  _buildLastName(),
                  _buildEmail(),
                  _buildPassword(),
                  _buildPasswordVaildation(),
                  CurrencyPicker(onChooseCurrency: onChooseCurrency, currentCurrency: CurrencyService().findByCode(Strings.USD),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                        visible: _isLoading,
                        child: CircularProgressIndicator()
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                        visible: _isErr,
                        child: showAlert(_errMsg, () {
                          setState(() {
                            _isErr = false;
                          });
                        })
                    ),
                  ),                  nextButton(
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      if (!(await validateEmail(_email))) {
                        setState(() {
                          _isErr = true;
                          _errMsg = "The email you provided does not exist. Please provide a valid email";
                        });
                        print("The email you provided does not exist. Please provide a valid email");
                        return null;
                      }


                      _continuePressed();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
