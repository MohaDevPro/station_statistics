import 'package:floor/floor.dart';
import 'package:intl/intl.dart' as intl;

@entity
class Invoice {
  @PrimaryKey()
  final int? id;
  int? timeStamp;
  // String? type;
  double? totalPrice;
  double? tax;
  // double? price;
  // double? quantity;
  Invoice({
    this.id,
    this.timeStamp,
    // this.type,
    this.totalPrice,
    this.tax,
    // this.price,
    // this.quantity,
  });

  String? getIndex(int index, int row) {
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd hh:mm:ss');
    switch (index) {
      case 3:
        return (row + 1).toString();
      case 2:
        return formatter
            .format(DateTime.fromMicrosecondsSinceEpoch(timeStamp!))
            .toString();
      case 1:
        return totalPrice.toString();
      case 0:
        return "% " + tax!.toInt().toString();
    }
    return '';
  }
}
