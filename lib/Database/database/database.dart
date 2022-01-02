import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:station_statistics/Database/DOA/InvoiceDAO.dart';
import 'package:station_statistics/Database/DOA/UsersDAO.dart';
import 'package:station_statistics/Database/DOA/invoice_item_dao.dart';
import 'package:station_statistics/Database/Entities/Invoices.dart';
import 'package:station_statistics/Database/Entities/User.dart';
import 'package:station_statistics/Database/Entities/invoice_items.dart';

part 'database.g.dart';

@Database(version: 1, entities: [
  User,
  Invoice,
  InvoiceItem,
])
abstract class AppDatabase extends FloorDatabase {
  UserDAO get userDAO;
  InvoiceDAO get invoiceDAO;
  InvoiceItemDAO get invoiceItemDAO;
}

// flutter packages pub run build_runner build
// flutter packages pub run build_runner build --delete-conflicting-outputs
