import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:station_statistics/Controller/items_controller.dart';
import 'package:station_statistics/Controller/pdf_preview.dart';
import 'package:station_statistics/Controller/report_screen.dart';
import 'package:station_statistics/Database/Entities/Invoices.dart';
import 'package:station_statistics/Database/Entities/invoice_items.dart';
import 'package:station_statistics/Screens/AddUsers.dart';
import 'package:station_statistics/Screens/Login.dart';
import 'package:station_statistics/Services/user_preferences.dart';

import '../Services/LocalDB.dart';
import '../constaint.dart';
import 'cart_screen.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

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
  final itemController = Get.put(ItemsGetX());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('الرئيسية'),
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
                  icon: Icon(
                    Icons.image,
                    textDirection: TextDirection.ltr,
                  ),
                  onPressed: () async {
                    await PickImage.pick();
                  }),
              IconButton(
                  icon: Icon(Icons.print),
                  onPressed: () async {
                    if (UserPreferences().prefs.getString("path") != null) {
                      if (itemController.listItemsCart.isNotEmpty) {
                        var total = 0.0;
                        for (var i in itemController.listItemsCart) {
                          total += double.parse(
                              (i.price! * i.quantity!).toStringAsFixed(2));
                        }
                        var invoice = Invoice(
                          totalPrice: double.parse(total.toStringAsFixed(2)),
                          timeStamp: DateTime.now().microsecondsSinceEpoch,
                          tax: 15.0,
                        );
                        var invoiceID = await LocalDB()
                            .appDatabaseCache
                            .invoiceDAO
                            .insertInvoice(invoice);
                        for (var i in itemController.listItemsCart) {
                          await LocalDB()
                              .appDatabaseCache
                              .invoiceItemDAO
                              .insertInvoiceItem(
                                InvoiceItem(
                                  price: i.price,
                                  quantity: i.quantity,
                                  invoiceID: invoiceID,
                                  type: i.type,
                                ),
                              );
                        }
                        itemController.clearItems();
                      }
                      var lastInvoice = await LocalDB()
                          .appDatabaseCache
                          .invoiceDAO
                          .getAllInvoices();
                      if (lastInvoice.isNotEmpty) {
                        Get.to(
                            () => PDFPreview(
                                  data: [
                                    lastInvoice.last,
                                  ],
                                  invoiceNumber: lastInvoice.last.id,
                                ),
                            preventDuplicates: true);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            message: "لا يوجد فواتير",
                            color: Colors.blue.shade300,
                            confirmButton: () {
                              Get.back();
                            },
                            cancelButton: false,
                            confirmButtonTitle: "حسناً",
                          ),
                        );
                      }
                    } else {
                      await PickImage.pick();
                    }
                  }),
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
          body: Stack(
            children: [
              Column(
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
                            color: selected == 0
                                ? Colors.blue.shade100
                                : Colors.white,
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
                            color: selected == 1
                                ? Colors.blue.shade100
                                : Colors.white,
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
                            color: selected == 2
                                ? Colors.blue.shade100
                                : Colors.white,
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
                            text: "المجموع: ",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
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
                                  'السعر',
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
                                  'الكمية',
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
                                      autofocus: false,
                                      textAlign: TextAlign.center,
                                      focusNode: fn,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('.[0-9]*')),
                                      ],
                                      validator: (v) {
                                        if (v!.isEmpty)
                                          return 'حقل مطلوب';
                                        // else if (v.length < 9)
                                        //   return ' أقل من 9 أرقام';
                                        else
                                          return null;
                                      },
                                      onChanged: (value) {
                                        if (value != '') {
                                          setState(() {
                                            total = price * double.parse(value);
                                            total = double.parse(
                                                total.toStringAsFixed(2));
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
                          'formKey.currentState.validate() ${formKey.currentState!.validate()}');
                      if (selected != -1 &&
                          formKey.currentState!.validate() &&
                          double.parse(controller.text) != 0) {
                        itemController.addItems(
                          InvoiceItem(
                            type: selected == 0
                                ? '95'
                                : selected == 1
                                    ? '91'
                                    : 'D',
                            quantity: double.parse(controller.text),
                            price: price,
                          ),
                        );
                        price = 0.0;
                        total = 0.0;
                        controller.clear();
                        selected = -1;
                        // var result =
                        //     await LocalDB().appDatabaseCache.invoiceDAO.insertInvoice(
                        //           Invoice(
                        //             type: selected == 0
                        //                 ? '95'
                        //                 : selected == 1
                        //                     ? '91'
                        //                     : 'D',
                        //             price: price,
                        //             quantity: double.parse(controller.text),
                        //             timeStamp: DateTime.now().microsecondsSinceEpoch,
                        //             totalPrice: total,
                        //           ),
                        //         );
                        // print("result $result");
                        // if (result > 0) {
                        //   setState(() {
                        //     price = 0.0;
                        //     total = 0.0;
                        //     controller.text = '';
                        //     selected = -1;
                        //   });
                        //   var lastInvoice = await LocalDB()
                        //       .appDatabaseCache
                        //       .invoiceDAO
                        //       .getAllInvoices();
                        //   if (lastInvoice.isNotEmpty) {
                        //     Get.to(
                        //         () => PDFPreview(
                        //               data: [
                        //                 lastInvoice.last,
                        //               ],
                        //               invoiceNumber: lastInvoice.last.id,
                        //             ),
                        //         preventDuplicates: true);
                        //   } else {
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) => CustomDialog(
                        //         message: "لا يوجد فواتير",
                        //         color: Colors.blue.shade300,
                        //         confirmButton: () {
                        //           Get.back();
                        //         },
                        //         cancelButton: false,
                        //         confirmButtonTitle: "حسناً",
                        //       ),
                        //     );
                        //   }
                        // } else {
                        //   showDialog(
                        //     context: context,
                        //     builder: (context) => CustomDialog(
                        //       message: 'فشل الحفظ حاول مرة اخرى',
                        //       confirmButton: () {
                        //         Get.back();
                        //       },
                        //       cancelButton: false,
                        //       color: Colors.redAccent,
                        //       confirmButtonTitle: 'حسناً',
                        //       icon: Icons.cancel,
                        //     ),
                        //   );
                        // }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            message: "الرجاء اختيار نوع",
                            confirmButton: () {
                              Get.back();
                            },
                            color: Colors.blue.shade300,
                            cancelButton: false,
                            confirmButtonTitle: 'حسناً',
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("حفظ"),
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
              GetBuilder<ItemsGetX>(
                builder: (controller) => itemController.listItemsCart.isNotEmpty
                    ? Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: ElevatedButton(
                          onPressed: () async {
                            Get.to(() => CartScreen());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.shopping_cart),
                                Text(
                                  "الذهاب إلى السلة ",
                                  style: facilityTitle.copyWith(
                                      color: Colors.white),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF222327),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: Text(
                                        itemController.listItemsCart.length
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0.0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PickImage {
  static Future pick() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    var dir = await getApplicationDocumentsDirectory();

    if (image != null) {
      print(image.path.split(".").last);
      var path = dir.path + "/" + image.path;
      // var r = await Directory(dir.path).delete(recursive: true);
      // print("Directory(path).de $r");
      UserPreferences().prefs.setString("path", path);
      if (await Directory(path).exists()) {
        print("existsc");
        await image.saveTo(path);
      } else {
        await File(path).create(recursive: true);
        await image.saveTo(path);
      }
    }
  }
}
