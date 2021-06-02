
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/repository/repository.dart';
import '../api/cars_api.dart';
import '../api/user.dart';
import '../api/sign_up.dart';
enum carTypes { allTypes, family, sports, mini, offRoad }
class CarsGlobals {
  static UserApi userApi = QuickCarUserApi();
  static SignUpApi signUpApi = QuickCarSignUpApi();
  static CarsApi carsApi = QuickCarCarsApi();
  static Repository repository = Repository();
  static const List<String> carTypes = <String>['All types', 'Family', 'Sports', 'Mini', 'Off-road'];
  static const List<String> companies = <String>[
    "Acura",
    "Alfa romeo",
    "Aro",
    "Asia",
    "Aston martin",
    "Audi",
    "Bentley",
    "Bmw",
    "Brilliance",
    "Bugatti",
    "Buick",
    "Byd",
    "Cadillac",
    "Chery",
    "Chevrolet",
    "Chrysler",
    "Citroen",
    "Dacia",
    "Daewoo",
    "Daf",
    "Daihatsu",
    "Daimler",
    "Derways",
    "Dodge",
    "Eagle",
    "Faw",
    "Ferrari",
    "Fiat",
    "Ford",
    "Freightliner",
    "Gaz",
    "Geely",
    "Gmc",
    "Great wall",
    "Harley davidson",
    "Hino",
    "Honda",
    "Hummer",
    "Hyundai",
    "Ifa",
    "Ig",
    "Infiniti",
    "International",
    "Isuzu",
    "Iveco",
    "Jaguar",
    "Jeep",
    "Kamaz",
    "Kavz",
    "Kawasaki",
    "Kia",
    "Kraz",
    "Lamborghini",
    "Lancia",
    "Land rover",
    "Laz",
    "Lexus",
    "Liaz",
    "Lifan",
    "Lincoln",
    "Luaz",
    "Man",
    "Marz",
    "Maserati",
    "Maybach",
    "Maz",
    "Mazda",
    "Mercedes benz",
    "Mercury",
    "Mg",
    "Mini",
    "Mitsubishi",
    "Mitsuoka",
    "Moscvich",
    "Neoplan",
    "Nissan",
    "Nyssa",
    "Oldsmobile",
    "Opel",
    "Peugeot",
    "Plymouth",
    "Pontiac",
    "Porsche",
    "Proton",
    "Reliant",
    "Renault",
    "Renault samsung",
    "Rolls-royce",
    "Rover",
    "Saab",
    "Saturn",
    "Scion",
    "Seat",
    "Skoda",
    "Smart",
    "Ssang yong",
    "Subaru",
    "Talbot",
    "Tanye",
    "Tatra",
    "Tianye",
    "Toyota",
    "Uaz",
    "Ural",
    "Vauxhall",
    "Vaz",
    "Volkswagen",
    "Volvo",
    "Xin kai",
    "Zaz",
    "Zil",
  ];
  static const double MAX_DISTANCE = 100.0;
  static void setApplicationDocumentsDirectoryPath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    Strings.APPLICATION_DOCUMENTS_DIRECTORY_PATH = directory.path;
    print("app documents directory path set successfully");
  }
  static final picker = ImagePicker();
  static const List<String> startDriveAngles = ["front", "side 1", "back", "side 2"];
  static const int maximumCarImages = 4;
}