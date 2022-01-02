import 'package:floor/floor.dart';
import 'package:station_statistics/Database/Entities/invoice_items.dart';

@dao
abstract class InvoiceItemDAO {
  @Query("SELECT * FROM InvoiceItem")
  Future<List<InvoiceItem>> getAllInvoiceItems();

  @Query("SELECT * FROM InvoiceItem where invoiceID = :id")
  Future<List<InvoiceItem>> getAllInvoiceItemsInvoiceID(int id);

  @Query("SELECT * FROM InvoiceItem where itemID = :id")
  Future<List<InvoiceItem>> getAllInvoiceItemsByItemID(int id);

  @Query("SELECT * FROM InvoiceItem where id = :id")
  Future<InvoiceItem?> getInvoiceItemByInvoiceItemID(int id);

  @Query("SELECT * FROM InvoiceItem where itemID = :id")
  Future<InvoiceItem?> getInvoiceItemByItemID(int id);

  @Query("SELECT * FROM InvoiceItem where invoiceID = :id")
  Future<InvoiceItem?> getInvoiceItemByInvoiceID(int id);

  @Query("DELETE FROM InvoiceItem")
  Future<void> deleteAllInvoiceItems();

  @insert
  Future<int> insertInvoiceItem(InvoiceItem invoiceItem);

  @insert
  Future<List<int>> insertListInvoiceItem(List<InvoiceItem> invoiceItems);

  @update
  Future<void> updateInvoiceItem(InvoiceItem invoiceItem);

  @delete
  Future<void> deleteInvoiceItem(InvoiceItem invoiceItem);
}
