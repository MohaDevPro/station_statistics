import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/User.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._const();
  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._const();

  SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  UserModel getUser() {
    return UserModel(
      id: prefs.getInt('userId'),
      userName: prefs.getString('username'),
      type: prefs.getInt('type'),
    );
  }

  setUser(UserModel user) {
    prefs.setInt('userId', user.id);
    prefs.setString('username', user.userName);
    prefs.setInt('type', user.type);
  }

  deleteUser() {
    prefs.clear();
  }
}
