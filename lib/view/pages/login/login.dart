import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/quick_car/user_signin.dart';
import 'package:quick_car/data_class/quick_car/user_signup.dart';
import 'package:quick_car/states/user_state.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
    String _email;
    String _password;
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
                          prefixIcon: Icon(IconData(0xe6f3, fontFamily: 'MaterialIcons'), color: Colors.blue,)
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
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
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom:30),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("Forgot password ?",style: TextStyle(color: Colors.blue,fontSize: 12),)),
                  ),
                InkWell(
                  onTap: () async {
                      var token;
                      Globals.userApi.login(UserSignIn(email: emailController.text, password: passwordController.text))
                          .then((value) {
                            token = value;
                            userState.setToken(token);
                            print("token gotton after login ${token}");
                            Strings.TOKEN = token;
                            // should ask for all the personal details and put them in the state
                            userState.setFirstName("Ori");
                            userState.setIsLoggedIn(true);
                            Navigator.pushReplacementNamed(context, '/');
                          }).catchError((error, stackTrace) => print("error:" +error.toString()));
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
                                      Navigator.pushNamed(context, '/signup');                                    }
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

  Container ContinueWith(String image) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0,3),
                color: Colors.grey,
                blurRadius: 5
            )
          ]

      ),
      child: Image.asset(image,),
    );
  }
}
