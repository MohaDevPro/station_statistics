import 'package:floor/floor.dart';

@entity
class InvoiceItem {
  @PrimaryKey()
  final int? id;
  int? invoiceID;
  String? type;
  double? price;
  double? quantity;

  InvoiceItem({
    this.id,
    this.invoiceID,
    this.type,
    this.price,
    this.quantity,
  });
  String? getIndex(int index, int row) {
    switch (index) {
      case 2:
        return type;
      case 1:
        return price.toString();
      case 0:
        return quantity.toString();
    }
    return '';
  }
}
