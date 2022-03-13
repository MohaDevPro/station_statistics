import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:station_statistics/Controller/user_controller.dart';
import 'package:station_statistics/Screens/Login.dart';
import 'package:station_statistics/Services/user_preferences.dart';

import '../constaint.dart';
import '../main.dart';

class LoginSerial extends StatelessWidget {
  LoginSerial({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var userNameCon = TextEditingController();
  var userFN = FocusNode();
  UserPreferences userPreferences = UserPreferences();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.blue.shade400,
        body: SingleChildScrollView(
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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
                              labelText: "أدخل رمز التفعيل",
                              helperText: "أدخل رمز التفعيل",
                              prefixIcon: Icon(Icons.text_fields)),
                          autofocus: true,
                          focusNode: userFN,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.allow(RegExp('7[0-9]*')),
                          // ],
                          validator: (v) {
                            if (v!.isEmpty)
                              return 'حقل مطلوب';
                            else if (v.length < 3)
                              return 'أقل من 3 حروف';
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
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => LoadingScreen());

                              bool result = await UserController.isRegister(
                                  userNameCon.text);
                              print("result $result");
                              if (result) {
                                Navigator.pop(context);
                                Get.off(() => Login());
                              } else {
                                Navigator.pop(context);
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    // message:
                                    //     'Error in login, ensure of username and password',
                                    message:
                                        'خطأ في تسجيل الدخول تأكد من رمز التفعيل',
                                    confirmButton: () {
                                      Navigator.pop(context);
                                    },
                                    cancelButton: false,
                                    confirmButtonTitle: 'حسناً',
                                  ),
                                );
                              }
                            } else {
                              if (userNameCon.text == '' ||
                                  userNameCon.text.length < 3)
                                userFN.requestFocus();
                              // else if (passCon.text == '' ||
                              //     passCon.text.length < 8)
                              //   passFN.requestFocus();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text("تسجيل الرمز"),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
