import 'package:quick_car/api/quick_car_api/cars_api.dart';
import 'package:quick_car/api/quick_car_api/user.dart';
import 'package:quick_car/api/quick_car_api/sign_up.dart';
import 'package:quick_car/data_class/quick_car/user_signup.dart';

class Globals {
  // mock users after sign-up in a MockSignUpApi
  static List<UserSignUp> users = [];
  static UserApi userApi = QuickCarUserApi();
  static SignUpApi signUpApi = QuickCarSignUpApi();
  static CarsApi carsListApi = QuickCarCarsApi();
}