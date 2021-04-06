import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/states/user_state.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<UserState>(
        builder: (context, userState, child) {
          if (userState.isLoggedIn()) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("user has successfully logged in"),
                  TextButton(
                    onPressed: () {
                      userState.setIsLoggedIn(false);
                    },
                    child: Text("log out"),
                  )
                ],
              ),
            );
          } else {
            return Center(
                child: TextButton(
                  child: Center(
                      child: Text("click to log in")
                  ),
                  onPressed: () {
                    print(userState.isLoggedIn());
                    Navigator.pushNamed(context, '/login');
                  },
                )
            );
          }
        },
      )
    );
  }
}
