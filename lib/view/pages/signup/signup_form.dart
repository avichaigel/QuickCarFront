import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/constants/cars_globals.dart';
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
  String _userName;
  String _email;
  String _password;
  String _url;
  String _phoneNumber;
  String _country;

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
  Widget _buildUserName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'User name'),
      maxLength: 15,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Last name is Required';
        }
        if (!RegExp
        (r"^(?=.{1,15}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$").hasMatch(value)
        )
          return 'Please enter a valid user name';
        return null;
      },
      onSaved: (String value) {
        _userName = value;
      },
    );
  }
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPassword() {
    int minPwdLen = 2;
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
  Widget _buildCountry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 22.0, bottom: 2.0),
          child: Text(
            'Country',
            style: TextStyle(
                fontSize: 16.5,
                color: Colors.black54
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CountryList(
            onSelectParam: (String param) {
              _country = param;
            },
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    print("in signup form dispose");
    super.dispose();
  }

  void _continuePressed() {
    UserSignUp nu = UserSignUp();
    nu.username = _email;
    nu.firstName = _firstName;
    nu.lastName = _lastName;
    nu.email = _email;
    nu.password = _password;
    CarsGlobals.signUpApi.signUpNewUser(nu);
    context
        .flow<SignUpState>()
        .update((signUpState) => signUpState.copyWith(formCompleted: true));
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
                  SizedBox(height: 100),
                  nextButton(onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
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