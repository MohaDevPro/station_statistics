import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:station_statistics/Database/Entities/invoice_items.dart';
//
// class InvoiceItem {
//  
//   String description;
//   double quantity;
//   double price;
//
//   InvoiceItem({
//     required this.quantity,
//     required this.price,
//     required this.description,
//   });
// }

class ItemsGetX extends GetxController {
  List<InvoiceItem> _listItemsCart = [];

  List<InvoiceItem> get listItemsCart => _listItemsCart;
  settItems(List<InvoiceItem> listItemsCart) {
    _listItemsCart = listItemsCart;
    update();
  }

  addItems(InvoiceItem invoiceItem) {
    _listItemsCart.add(invoiceItem);
    update();
  }

  // updatePrice(InvoiceItem invoiceItem) {
  //   var invoiceItemQuantity = _listItemsCart
  //       .where((element) => element.invoiceItem.id == invoiceItem.invoiceItem.id)
  //       .first;
  //   // invoiceItemQuantity.quantity += 1;
  //   invoiceItemQuantity.price = invoiceItem.price;
  //   update();
  // }
  //
  // updateQuantity(InvoiceItem invoiceItem) {
  //   var invoiceItemQuantity = _listItemsCart
  //       .where((element) => element.invoiceItem.id == invoiceItem.invoiceItem.id)
  //       .first;
  //   invoiceItemQuantity.quantity += invoiceItem.quantity;
  //   // invoiceItemQuantity.price =
  //   //     invoiceItemQuantity.quantity * invoiceItemQuantity.invoiceItem.price!.toDouble();
  //   update();
  // }

  // removeItems(InvoiceItem invoiceItem) {
  //   var invoiceItemQuantity = _listItemsCart
  //       .where((element) => element.invoiceItem.id == invoiceItem.invoiceItem.id)
  //       .first;
  //   invoiceItemQuantity.quantity -= 1;
  //   invoiceItemQuantity.price =
  //       invoiceItemQuantity.quantity * invoiceItemQuantity.invoiceItem.price!.toDouble();
  //   update();
  // }

  remove(int index) {
    listItemsCart.removeAt(index);
    update();
  }

  // bool sureContains(int id) {
  //   var invoiceItemQuantity =
  //       _listItemsCart.where((element) => element.invoiceItem.id == id).toList();
  //
  //   return invoiceItemQuantity.isEmpty ? false : true;
  // }

  getItems() {
    return _listItemsCart;
  }

  justUpdate() {
    update();
  }

  clearItems() {
    _listItemsCart = [];
    update();
  }
}
