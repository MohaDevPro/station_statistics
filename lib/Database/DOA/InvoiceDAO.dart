import 'package:floor/floor.dart';
import 'package:station_statistics/Database/Entities/Invoices.dart';
// import 'package:flutter/'

@dao
abstract class InvoiceDAO {
  @Query("SELECT * FROM Invoice")
  Future<List<Invoice>> getAllInvoices();

  @Query("SELECT * FROM Invoice where timeStamp >= :from and timeStamp <= :to")
  Future<List<Invoice>> getAllInvoicesBetweenDates(int from, int to);

  @Query("SELECT * FROM Invoice where id = :id ")
  Future<Invoice> getInvoice(int id);

  @Query("DELETE FROM Invoice")
  Future<void> deleteAllInvoices();

  @insert
  Future<int> insertInvoice(Invoice invoice);

  @update
  Future<int> updateInvoice(Invoice invoice);

  @update
  Future<int> updateAllInvoice(List<Invoice> invoices);

  @delete
  Future<void> deleteInvoice(Invoice invoice);
}
