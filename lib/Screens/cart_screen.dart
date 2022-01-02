import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:station_statistics/Controller/items_controller.dart';
import 'package:station_statistics/Controller/pdf_preview.dart';
import 'package:station_statistics/Database/Entities/Invoices.dart';
import 'package:station_statistics/Database/Entities/invoice_items.dart';
import 'package:station_statistics/Services/LocalDB.dart';

import '../constaint.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);
  final itemController = Get.put(ItemsGetX());
  final db = LocalDB();
  // var tax = TextEditingController();
  // var discount = TextEditingController();
  double total = 0.0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("السلة"),
        ),
        body: GetBuilder<ItemsGetX>(builder: (controller) {
          total = 0.0;
          for (var i in controller.listItemsCart) {
            total += double.parse((i.price! * i.quantity!).toStringAsFixed(2));
            // total += i.totalPrice;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.listItemsCart.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              // height: 80,
                              // width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "النوع: " +
                                                controller
                                                    .listItemsCart[index].type
                                                    .toString(),
                                            style: facilityTitle,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            " السعر:   " +
                                                controller
                                                    .listItemsCart[index].price
                                                    .toString(),
                                            style: facilityTitle,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            " الكمية:   " +
                                                controller.listItemsCart[index]
                                                    .quantity
                                                    .toString() +
                                                "لتر",
                                            style: facilityTitle,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // IconButton(
                                              //   icon: const Icon(Icons.add),
                                              //   color: Colors.red,
                                              //   highlightColor: Colors.white,
                                              //   splashColor: Colors.white,
                                              //   splashRadius: 50,
                                              //   onPressed: () {
                                              //     print(itemController
                                              //       ..listItemsCart.length);
                                              //     // itemController.updateItems(
                                              //     //     ItemWithQuantity(
                                              //     //         item: controller
                                              //     //             .listItemsCart[index]
                                              //     //             .item,
                                              //     //         quantity: 1,
                                              //     //         price: 0));
                                              //   },
                                              // ),
                                              // Container(
                                              //   // margin: const EdgeInsets.only(left: 10),
                                              //   decoration: const BoxDecoration(
                                              //     shape: BoxShape.circle,
                                              //     color: Colors.blue,
                                              //   ),
                                              //   padding:
                                              //       const EdgeInsets.all(11),
                                              //   child: Center(
                                              //     child: AnimatedContainer(
                                              //       duration: const Duration(
                                              //           milliseconds: 500),
                                              //       curve: Curves
                                              //           .fastLinearToSlowEaseIn,
                                              //       child: Text(
                                              //         "x" +
                                              //             controller
                                              //                 .listItemsCart[
                                              //                     index]
                                              //                 .quantity
                                              //                 .toString(),
                                              //         style: facilityTitleWhite,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                color: Colors.red,
                                                highlightColor: Colors.white,
                                                splashColor: Colors.white,
                                                splashRadius: 50,
                                                onPressed: () {
                                                  itemController.remove(index);

                                                  print(
                                                      "controller.listItemsCart[index].quantity ${controller.listItemsCart[index].quantity}");
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      " المجموع:   " +
                                          (controller.listItemsCart[index]
                                                      .price! *
                                                  controller
                                                      .listItemsCart[index]
                                                      .quantity!)
                                              .toStringAsFixed(2),
                                      style:
                                          facilityTitle.copyWith(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 4,
                      color: Colors.black,
                      endIndent: 10,
                      indent: 10,
                    ),
                    Container(
                      width: Get.width,
                      height: Get.height / 5,
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          // TextFormField(
                          //   controller: tax,
                          //   decoration: inputStyle(
                          //       labelText: "الضريبة المضافة",
                          //       helperText: "الضريبة المضافة",
                          //       prefixIcon: const Icon(Icons.add)),
                          //   autofocus: true,
                          //   onChanged: (value) {
                          //     itemController.justUpdate();
                          //   },
                          //   // focusNode: userFN,
                          //   inputFormatters: [
                          //     FilteringTextInputFormatter.allow(
                          //         RegExp('[0-9.]')),
                          //   ],
                          //   // validator: (v) {
                          //   //   if (v!.isEmpty) {
                          //   //     return 'حقل مطلوب';
                          //   //   } else if (v.length < 3) {
                          //   //     return 'أقل من 3 أحرف';
                          //   //   } else {
                          //   //     return null;
                          //   //   }
                          //   // },
                          //   keyboardType: TextInputType.number,
                          //   textInputAction: TextInputAction.next,
                          //   maxLength: 30,
                          // ),
                          // TextFormField(
                          //   controller: discount,
                          //   decoration: inputStyle(
                          //       labelText: "الخصم",
                          //       helperText: "الخصم",
                          //       prefixIcon: const Icon(Icons.money_off)),
                          //   autofocus: true,
                          //   onChanged: (value) {
                          //     itemController.justUpdate();
                          //   },
                          //   // focusNode: userFN,
                          //   inputFormatters: [
                          //     FilteringTextInputFormatter.allow(
                          //         RegExp('[0-9.]')),
                          //   ],
                          //   keyboardType: TextInputType.number,
                          //   textInputAction: TextInputAction.next,
                          //   maxLength: 30,
                          // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "المجموع الكلي: ",
                                style: facilityTitle.copyWith(
                                    fontSize: 17, color: Colors.black),
                              ),
                              Text(
                                total.toStringAsFixed(2),
                                style: facilityTitle.copyWith(
                                    fontSize: 17, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "الضريبة: ",
                                style: facilityTitle.copyWith(
                                    fontSize: 17, color: Colors.black),
                              ),
                              Text(
                                "${((total * 15) / 100).toStringAsFixed(2)}",
                                style: facilityTitle.copyWith(
                                    fontSize: 17, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "المجموع الصافي: ",
                                style: facilityTitle.copyWith(
                                    fontSize: 17, color: Colors.black),
                              ),
                              Text(
                                (total + (total * 15) / 100).toStringAsFixed(2),
                                style: facilityTitle.copyWith(
                                    fontSize: 17, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: GetBuilder<ItemsGetX>(
                    builder: (controller) => ElevatedButton(
                      onPressed: () async {
                        if (itemController.listItemsCart.isNotEmpty) {
                          print("DateTime.now() ${DateTime.now()}");
                          var invoice = Invoice(
                            totalPrice: double.parse(total.toStringAsFixed(2)),
                            timeStamp: DateTime.now().microsecondsSinceEpoch,
                            // userID: UserPreferences().getUser().id,
                            // discount: double.parse(
                            //     discount.text.isEmpty ? "0" : discount.text),
                            tax: 15.0,
                          );
                          var invoiceID = await db.appDatabaseCache.invoiceDAO
                              .insertInvoice(invoice);
                          for (var i in controller.listItemsCart) {
                            await db.appDatabaseCache.invoiceItemDAO
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
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => CustomDialog(
                              // message: 'Done add user successfully',
                              message: 'تم حفظ الفاتورة بنجاح',
                              confirmButton: () {
                                Get.back();
                                print(
                                    "invoice ${invoice.totalPrice} $invoiceID");
                                Get.off(
                                  () => PDFPreview(
                                    data: [invoice],
                                    invoiceNumber: invoiceID,
                                  ),
                                );
                              },
                              icon: Icons.check_circle,
                              cancelButton: false,
                              confirmButtonTitle: "حسناً",
                              color: const Color(0xFF2BBF8A),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.save),
                            Text(
                              "حفظ وطباعة ",
                              style: facilityTitleWhite,
                            ),
                            const Icon(Icons.print),
                            // TextButton.icon(
                            //   onPressed: () {},
                            //   icon: const Icon(
                            //     Icons.print,
                            //     color: Colors.white,
                            //   ),
                            //   label: Text(
                            //     "حفظ وطباعة",
                            //     style: facilityTitle,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0.0),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
