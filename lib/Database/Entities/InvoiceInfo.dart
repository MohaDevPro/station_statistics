import 'package:floor/floor.dart';

@entity
class InvoiceInfo {
  @PrimaryKey()
  final int? id;
  int? timeStamp;
  int? number;

  InvoiceInfo({
    this.id,
    this.timeStamp,
    this.number,
  });
}
