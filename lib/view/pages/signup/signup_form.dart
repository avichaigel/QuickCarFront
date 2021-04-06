import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/models/new_user.dart';
import 'package:quick_car/models/new_user.dart';
import 'package:quick_car/view/widgets/country_list_pick.dart';


class SignUpForm extends StatefulWidget {
  NewUser user;
  SignUpForm(this.user);
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
  BoxDecoration customDecoration ()
  {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          offset: Offset(0,2),
          color: Colors.grey[300],
          blurRadius: 5,
        )],
    );
  }

  Widget _buildFirstName() {
    return TextFormField(
          decoration: InputDecoration(labelText: 'First name'),
          maxLength: 10,
          validator: (String value) {
            if (value.isEmpty) {
              return 'First name is Required';
            }
            return null;
          },
          onSaved: (String value) {
            print("in saved");
            _firstName = value;
          },
    );
  }
  Widget _buildLastName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Last name'),
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
        if (value.length < 8) {
          return "Password must be atleast 8 characters long";
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
      decoration: InputDecoration(labelText: 'Confirm password'),
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
  Widget build(BuildContext context) {
    NewUser newUser = NewUser();
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
                  _buildUserName(),
                  _buildEmail(),
                  _buildPassword(),
                  _buildPasswordVaildation(),
                  _buildCountry(),
                  SizedBox(height: 100),
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context,
                          '/license');
                      print(_country);
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}