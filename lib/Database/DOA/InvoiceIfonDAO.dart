import 'package:floor/floor.dart';
import 'package:station_statistics/Database/Entities/InvoiceInfo.dart';
// import 'package:flutter/'

@dao
abstract class InvoiceInfoDAO {
  @Query("SELECT * FROM InvoiceInfo")
  Future<List<InvoiceInfo>> getAllInvoiceInfo();

  @Query("SELECT * FROM InvoiceInfo where id = :id ")
  Future<InvoiceInfo> getInvoiceInfo(int id);

  @Query("DELETE FROM InvoiceInfo")
  Future<void> deleteAllInvoiceInfo();

  @insert
  Future<int> insertInvoiceInfo(InvoiceInfo invoiceInfo);

  @update
  Future<int> updateInvoiceInfo(InvoiceInfo invoiceInfo);

  @delete
  Future<void> deleteInvoiceInfo(InvoiceInfo invoiceInfo);
}
