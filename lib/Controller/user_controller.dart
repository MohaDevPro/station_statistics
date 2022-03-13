import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:station_statistics/Models/user_api.dart';
import 'package:station_statistics/Services/my_crypto.dart';
import 'package:station_statistics/Services/user_preferences.dart';

import '../constaint.dart';

class UserController {
  static UserPreferences userPreferences = UserPreferences();
  static Future<bool> checkUserLoggedInForOrderConfirmation() async {
    if (userPreferences.prefs.containsKey('userToken'))
      return true;
    else
      return false;
  }

  static Future<UserAPI> fetchuserByID(int id) async {
    String Website_Url = '${Server.url}/Users/getusers/$id';

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      // HttpHeaders.authorizationHeader:
      //     userPreferences.prefs.getString("userToken"),
    };
    final http.Response websiteResponse =
        await http.get(Uri.parse(Website_Url), headers: headers);
    print(Website_Url);
    if (websiteResponse.statusCode == 200) {
      print('done');
      return UserAPI.fromJson(json.decode(websiteResponse.body));
    } else {
      return UserAPI(id: -1);
    }
  }

  static Future<bool> isRegister(String serial) async {
    String Website_Url = '${Server.url}/Users/isRegister/$serial';
    print(Website_Url);
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      // HttpHeaders.authorizationHeader:
      //     userPreferences.prefs.getString("userToken"),
    };
    final http.Response websiteResponse =
        await http.get(Uri.parse(Website_Url), headers: headers);

    if (websiteResponse.statusCode == 200) {
      if (json.decode(websiteResponse.body) == true) {
        userPreferences.prefs.setString("serial", serial);
      }

      print('done');
      return json.decode(websiteResponse.body);
    } else {
      return false;
    }
  }

  static Future serial(String serial) async {
    String Website_Url = '${Server.url}/Users/Serial/$serial';
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      // HttpHeaders.authorizationHeader:
      //     userPreferences.prefs.getString("userToken"),
    };
    print(Website_Url);
    // print(json.encode(serial));
    final http.Response websiteResponse = await http.post(
      Uri.parse(Website_Url),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        // HttpHeaders.authorizationHeader:
        //     userPreferences.prefs.getString("userToken"),

        //if the content type doesn't exist in post it will not execute
      },
      // body: json.encode(user.toJson()),
    );
    print(websiteResponse.body);
    print(websiteResponse.statusCode);
    if (websiteResponse.statusCode - 200 < 200) {
      userPreferences.prefs.setString("serial", serial);
      return true;
    }
    return false;
  }

  static saveUser(response) {
    UserAPI user = UserAPI.fromJson(json.decode(response));
    print(user);
    // userPreferences.prefs.setString("firstName", user.firstName);
    // userPreferences.prefs.setString("lastName", user.lastName);
    // userPreferences.prefs.setString("phone", user.phoneNumber);
    userPreferences.prefs.setString(
        "firstName", MyEncryptionDecryption.encryptAES(user.firstName).base64);
    userPreferences.prefs.setString(
        "lastName", MyEncryptionDecryption.encryptAES(user.lastName).base64);
    userPreferences.prefs.setString(
        "phone", MyEncryptionDecryption.encryptAES(user.phoneNumber).base64);
  }
}
