import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/view/widgets/messages.dart';
import '../../../data_class/user_signin.dart';
import 'package:quick_car/states/user_state.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _error;

  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  BoxDecoration customDecoration () {
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
  FocusNode myFocusNode;

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 130,
                  width: 130,
                  child: Image(
                    image: AssetImage("assets/car-marker.png"),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                SizedBox(height: 25,),
                Text("Welcome To QuickCar", textAlign: TextAlign.center ,style: TextStyle(fontSize: 26,fontWeight: FontWeight.w500),),
                SizedBox(height: 25,),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: customDecoration(),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon((Icons.email), color: Colors.blue,)
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                        onTap: () {
                          if (_error != null)
                            setState(() {
                              _error = null;
                            });
                        }
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: customDecoration(),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock_outline,color: Colors.blue,)
                    ),
                    controller: passwordController,
                    onTap: () {
                      if (_error != null)
                        setState(() {
                          _error = null;
                        });
                    },
                  ),
                ),
                // TODO: maybe delete it if will not be implemented
                Padding(
                    padding: const EdgeInsets.only(bottom:30),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("Forgot password ?",style: TextStyle(color: Colors.blue,fontSize: 12),)),
                  ),
                _error != null ?showAlert(_error, () {
                  setState(() {
                    _error = null;
                  });
                }) : Text(""),
                InkWell(
                  onTap: () async {
                    if (emailController.text == "") {
                      setState(() {
                        _error = "Email is required";
                      });
                      return;
                    }
                    if (passwordController.text == "") {
                      setState(() {
                        _error = "Password is required";
                      });
                      return;
                    }

                      CarsGlobals.userApi.login(UserSignIn(email: emailController.text, password: passwordController.text))
                          .then((value) {
                            userState.setToken(value.token);
                            print("token: ${value}");
                            Strings.TOKEN = value.token;
                            userState.setLoginSetup(value.id, value.firstName, value.lastName,
                                value.email, true, value.carLicense);
                            Navigator.pushReplacementNamed(context, '/');
                          }).catchError((error, stackTrace) {
                            setState(() {
                              print("error:");
                              print(error.runtimeType);
                              if (error.runtimeType == FormatException)
                                _error = "Wrong details";
                            });
                          } );
                  },
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.white,
                  hoverColor: Colors.blue,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0,2),
                          color: Colors.grey,
                          blurRadius: 5,
                        )],
                    ),
                    child: Center(child: Text("Login",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),)),
                  ),
                ),
                InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                        child: RichText(
                          text: TextSpan(
                              text: "New User? ",
                              style: TextStyle(color: Colors.grey[500], fontSize: 14,fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text: "Create an account",
                                  style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600, fontSize: 14),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(context, '/signup');
                                  }
                                )
                              ]),
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }
}
