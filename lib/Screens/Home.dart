import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:station_statistics/Screens/AddUsers.dart';
import 'package:station_statistics/Screens/Login.dart';
import 'package:station_statistics/Screens/ReportScreen.dart';
import 'package:station_statistics/Services/user_preferences.dart';

import '../Database/Entities/Invoices.dart';
import '../Services/LocalDB.dart';
import '../constaint.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var total = 0.0;

  var selected = -1;
  var price = 0.0;
  var formKey = GlobalKey<FormState>();
  UserPreferences userPreferences = UserPreferences();
  TextEditingController controller = TextEditingController();
  var fn = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.logout,
              textDirection: TextDirection.ltr,
            ),
            onPressed: () {
              UserPreferences().deleteUser();
              Get.off(() => Login());
            }),
        actions: [
          IconButton(
              icon: Icon(Icons.stacked_bar_chart),
              onPressed: () {
                Get.to(() => Report(), preventDuplicates: true);
              }),
          if (userPreferences.getUser().type == 0)
            IconButton(
                icon: Icon(Icons.person_add_sharp),
                onPressed: () {
                  Get.to(() => AddUsers(), preventDuplicates: true);
                }),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = 0;
                      price = 2.33;
                      if (controller.text != '') {
                        total = price * double.parse(controller.text);
                        total = double.parse(total.toStringAsFixed(2));
                      }
                    });
                  },
                  child: Card(
                    color: selected == 0 ? Colors.blue.shade100 : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(
                        //   Icons.local_gas_station_outlined,
                        //   size: 60,
                        // ),
                        Image.asset(
                          "assets/gas.png",
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitWidth,
                        ),
                        Text(
                          '95',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 40,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = 1;
                      price = 2.18;
                      if (controller.text != '') {
                        total = price * double.parse(controller.text);
                        total = double.parse(total.toStringAsFixed(2));
                      }
                    });
                  },
                  child: Card(
                    color: selected == 1 ? Colors.blue.shade100 : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/gas2.png",
                            width: 90,
                            height: 90,
                            fit: BoxFit.fitWidth,
                          ),
                          Text(
                            '91',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 40,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = 2;
                      price = 0.52;
                      if (controller.text != '') {
                        total = price * double.parse(controller.text);
                        total = double.parse(total.toStringAsFixed(2));
                      }
                    });
                  },
                  child: Card(
                    color: selected == 2 ? Colors.blue.shade100 : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/gas3.png",
                            width: 90,
                            height: 90,
                            fit: BoxFit.fitWidth,
                          ),
                          Text(
                            'D',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 40,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          RichText(
              softWrap: true,
              text: TextSpan(children: [
                TextSpan(
                    text: "Total: ",
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                TextSpan(
                    text: "$total",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 40,
                    ))
              ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          '$price',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Container(
                            width: Get.width / 3,
                            child: TextFormField(
                              controller: controller,
                              // decoration: inputStyle(
                              //     labelText: "Quantity",
                              //     prefixIcon: Icon(Icons.text_fields)),
                              autofocus: false, textAlign: TextAlign.center,
                              focusNode: fn,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('.[0-9]*')),
                              ],
                              validator: (v) {
                                if (v.isEmpty)
                                  return 'required';
                                // else if (v.length < 9)
                                //   return ' أقل من 9 أرقام';
                                else
                                  return null;
                              },
                              onChanged: (value) {
                                if (value != '') {
                                  setState(() {
                                    total = price * double.parse(value);
                                    total =
                                        double.parse(total.toStringAsFixed(2));
                                  });
                                } else {
                                  setState(() {
                                    total = 0.0;
                                  });
                                }
                              },
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              maxLength: 30,
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
          ElevatedButton(
            onPressed: () async {
              print(
                  'formKey.currentState.validate() ${formKey.currentState.validate()}');
              if (selected != -1 &&
                  formKey.currentState.validate() &&
                  int.parse(controller.text) != 0) {
                var result =
                    await LocalDB().appDatabaseCache.invoiceDAO.insertInvoice(
                          Invoice(
                            type: selected == 0
                                ? '95'
                                : selected == 1
                                    ? '91'
                                    : 'D',
                            price: price,
                            quantity: double.parse(controller.text),
                            timeStamp: DateTime.now().microsecondsSinceEpoch,
                            totalPrice: total,
                            isSaved: false,
                          ),
                        );
                print("result $result");
                if (result > 0) {
                  setState(() {
                    price = 0.0;
                    total = 0.0;
                    controller.text = '';
                    selected = -1;
                  });
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      message: 'Saved',
                      confirmButton: () {
                        Get.back();
                      },
                      cancelButton: false,
                      color: Color(0xFF2BBF8A),
                      confirmButtonTitle: 'Ok',
                      icon: Icons.check_circle,
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
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    message: "Please choose type",
                    confirmButton: () {
                      Get.back();
                    },
                    color: Colors.blue.shade300,
                    cancelButton: false,
                    confirmButtonTitle: 'Ok',
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Save"),
            ),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0.0),
              backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
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
    );
  }
}
