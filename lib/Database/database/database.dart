import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:station_statistics/Database/DOA/InvoiceDAO.dart';
import 'package:station_statistics/Database/DOA/UsersDAO.dart';
import 'package:station_statistics/Database/Entities/Invoices.dart';
import 'package:station_statistics/Database/Entities/User.dart';

part 'database.g.dart';

@Database(version: 1, entities: [
  User,
  Invoice,
])
abstract class AppDatabase extends FloorDatabase {
  UserDAO get userDAO;
  InvoiceDAO get invoiceDAO;
}

// flutter packages pub run build_runner build
