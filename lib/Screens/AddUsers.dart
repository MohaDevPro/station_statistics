import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:station_statistics/Services/LocalDB.dart';

import '../Database/Entities/User.dart';
import '../constaint.dart';
import '../main.dart';

class AddUsers extends StatelessWidget {
  AddUsers({Key key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var userNameCon = TextEditingController();
  var passCon = TextEditingController();
  var userFN = FocusNode();
  var passFN = FocusNode();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Add User'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(35)),
              ),
              child: Padding(
                padding: EdgeInsets.all(Get.width * 0.25),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Image.asset(
                    "assets/addUser.png",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: Get.height * 0.1,
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
                        if (v.isEmpty)
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
                            FilteringTextInputFormatter.deny(RegExp('[أ-ي]')),
                          ],
                          validator: (v) {
                            if (v.isEmpty)
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
                        if (formKey.currentState.validate()) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => LoadingScreen());

                          var result = await LocalDB()
                              .appDatabaseCache
                              .userDAO
                              .getUser(userNameCon.text, passCon.text);
                          print("result $result");

                          if (result == null) {
                            Navigator.pop(context);
                            var insert = await LocalDB()
                                .appDatabaseCache
                                .userDAO
                                .insertUser(
                                  User(
                                      userName: userNameCon.text,
                                      type: 1,
                                      password: passCon.text),
                                );
                            if (insert > 0) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => CustomDialog(
                                  message: 'Done add user successfully',
                                  // message: 'تم إضافة المستخدم بنجاح',
                                  confirmButton: () {
                                    Navigator.pop(context);
                                  },
                                  cancelButton: false,
                                  confirmButtonTitle: 'Ok',
                                  color: Color(0xFF2BBF8A),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  message: 'Field to save. Try again',
                                  confirmButton: () {
                                    Get.back();
                                  },
                                  cancelButton: false,
                                  color: Colors.redAccent,
                                  confirmButtonTitle: 'Ok',
                                  icon: Icons.cancel,
                                ),
                              );
                            }
                          } else {
                            Navigator.pop(context);
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => CustomDialog(
                                // message:
                                //     'اسم المستخدم موجود بالفعل',
                                message: 'Username already exist',
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
                              passCon.text.length < 8) passFN.requestFocus();
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
    );
  }
}
