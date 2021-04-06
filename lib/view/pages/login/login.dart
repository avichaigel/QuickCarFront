import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/api/quick_car_api/sign_in.dart';
import 'package:quick_car/data_class/quick_car/user_signin.dart';
import 'package:quick_car/states/user_state.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                Text("Welcome To ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                SizedBox(height: 25,),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: customDecoration(),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "User name",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.person_outline,color: Colors.blue,)
                      ),
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
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom:30),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("Forgot password ?",style: TextStyle(color: Colors.blue,fontSize: 12),)),
                  ),
                InkWell(
                  onTap: () {
                    userState.setIsLoggedIn(true);
                    print("login tapped");
                    UserSignIn usi = UserSignIn();
                    usi.username = "1";
                    usi.password = "5";
                    UserApi().signIn(usi);
                    Navigator.pushReplacementNamed(context, '/');
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
