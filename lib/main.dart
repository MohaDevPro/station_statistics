import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:station_statistics/Database/Entities/User.dart';
import 'package:station_statistics/Services/user_preferences.dart';

import 'Database/database/database.dart';
import 'Screens/Home.dart';
import 'Screens/Login.dart';
import 'Services/LocalDB.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // var d = DatabaseServices();
  // var u = await d.getAllUsers();
  // if (u.isEmpty) {
  //   await d.addUser("admin", "12345678", 0);
  // }
  await LocalDB().init();
  print("UserPreferences userPreferences = UserPreferences();");
  await UserPreferences().init();
  AppDatabase appDatabase =
      await $FloorAppDatabase.databaseBuilder('database.db').build();
  var admin = await appDatabase.userDAO.getUserByType(0);
  if (admin == null) {
    var d = appDatabase.userDAO
        .insertUser(User(type: 0, password: '12345678', userName: 'admin'));
    print('dddddddd $d');
  } else {
    print(admin.userName);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  UserPreferences userPreferences = UserPreferences();
  @override
  Widget build(BuildContext context) {
    // var dateTime = DateTime.now().millisecondsSinceEpoch;
    // var t = DateTime.fromMillisecondsSinceEpoch(dateTime);
    // // var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
    // print("============ ${DateTime.now()} =============");
    // print("============ ${dateTime} =============");
    // print("============ ${t} =============");
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: userPreferences.getUser().userName != null ? Home() : Login());
  }
}

InputDecoration inputStyle(
    {bool isFocused = false,
    String? helperText,
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon}) {
  return InputDecoration(
    filled: true,
    border: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    enabledBorder: outlineInputBorder,
    focusColor: Colors.blue,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    // labelStyle: TextStyle(fontFamily: FontFamilyNeoSans),
    // helperStyle: TextStyle(fontFamily: FontFamilyNeoSans),
    // icon: Icon(Icons.description),
    helperText: helperText,
    labelText: labelText,
    hintText: hintText,
    // hintText: 'مطعم العمودي للبروست',
  );
}

OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(
    width: 0,
    color: Color(0xFFDADFEF),
    style: BorderStyle.none,
  ),
  borderRadius: BorderRadius.all(
    Radius.circular(20),
  ),
);
