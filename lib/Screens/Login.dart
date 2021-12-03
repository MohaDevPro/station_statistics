import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:station_statistics/Screens/Home.dart';
import 'package:station_statistics/Screens/User.dart';
import 'package:station_statistics/Services/user_preferences.dart';

import '../Services/LocalDB.dart';
import '../constaint.dart';
import '../main.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var userNameCon = TextEditingController();
  var passCon = TextEditingController();
  var userFN = FocusNode();
  var passFN = FocusNode();
  bool isVisible = true;
  UserPreferences userPreferences = UserPreferences();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade400,
      body: Container(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      // borderRadius:
                      //     BorderRadius.vertical(bottom: Radius.circular(35)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Get.width * 0.25),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Image.asset(
                          "assets/password.png",
                        ),
                      ),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(35)),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: userNameCon,
                          decoration: inputStyle(
                              labelText: "Username",
                              helperText: "Username",
                              prefixIcon: Icon(Icons.text_fields)),
                          autofocus: true,
                          focusNode: userFN,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.allow(RegExp('7[0-9]*')),
                          // ],
                          validator: (v) {
                            if (v!.isEmpty)
                              return 'required';
                            else if (v.length < 3)
                              return 'less than 3 letters';
                            else
                              return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          maxLength: 30,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        StatefulBuilder(
                          builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return TextFormField(
                              textDirection: TextDirection.ltr,
                              controller: passCon,
                              obscureText: isVisible,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp('[أ-ي]')),
                              ],
                              validator: (v) {
                                if (v!.isEmpty)
                                  return 'required';
                                else if (v.length < 8)
                                  return ' less than 8 characters';
                                else
                                  return null;
                              },
                              autofocus: true,
                              focusNode: passFN,
                              decoration: inputStyle(
                                labelText: "Password",
                                helperText: "Password",
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                            );
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => LoadingScreen());

                              var result = await LocalDB()
                                  .appDatabaseCache
                                  .userDAO
                                  .getUser(userNameCon.text, passCon.text);
                              print("result $result");

                              if (result != null) {
                                Navigator.pop(context);
                                userPreferences.setUser(UserModel(
                                  id: result.id,
                                  userName: result.userName,
                                  type: result.type,
                                ));
                                Get.off(() => Home());
                              } else {
                                Navigator.pop(context);
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    message:
                                        'Error in login, ensure of username and password',
                                    // message:
                                    //     'خطأ في تسجيل الدخول تأكد من اسم المستخدم وكلمة السر',
                                    confirmButton: () {
                                      Navigator.pop(context);
                                    },
                                    cancelButton: false,
                                    confirmButtonTitle: 'Ok',
                                  ),
                                );
                              }
                            } else {
                              if (userNameCon.text == '' ||
                                  userNameCon.text.length < 3)
                                userFN.requestFocus();
                              else if (passCon.text == '' ||
                                  passCon.text.length < 8)
                                passFN.requestFocus();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text("Login"),
                          ),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0.0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade300),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
