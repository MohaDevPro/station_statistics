import 'package:floor/floor.dart';
import 'package:intl/intl.dart' as intl;

@entity
class Invoice {
  @PrimaryKey()
  final int? id;
  int? timeStamp;
  String? type;
  double? totalPrice;
  double? price;
  double? quantity;
  bool? isSaved;
  Invoice({
    this.id,
    this.timeStamp,
    this.type,
    this.totalPrice,
    this.price,
    this.quantity,
    this.isSaved,
  });

  String? getIndex(int index, int row) {
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd hh:mm:ss');
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return formatter
            .format(DateTime.fromMicrosecondsSinceEpoch(timeStamp!))
            .toString();
      case 2:
        return quantity.toString();
      case 3:
        return type;
      case 4:
        return price.toString();
      case 5:
        return totalPrice.toString();
    }
    return '';
  }
}
