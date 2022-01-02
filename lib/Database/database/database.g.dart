// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDAO? _userDAOInstance;

  InvoiceDAO? _invoiceDAOInstance;

  InvoiceItemDAO? _invoiceItemDAOInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userName` TEXT, `password` TEXT, `type` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Invoice` (`id` INTEGER, `timeStamp` INTEGER, `totalPrice` REAL, `tax` REAL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `InvoiceItem` (`id` INTEGER, `invoiceID` INTEGER, `type` TEXT, `price` REAL, `quantity` REAL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDAO get userDAO {
    return _userDAOInstance ??= _$UserDAO(database, changeListener);
  }

  @override
  InvoiceDAO get invoiceDAO {
    return _invoiceDAOInstance ??= _$InvoiceDAO(database, changeListener);
  }

  @override
  InvoiceItemDAO get invoiceItemDAO {
    return _invoiceItemDAOInstance ??=
        _$InvoiceItemDAO(database, changeListener);
  }
}

class _$UserDAO extends UserDAO {
  _$UserDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'password': item.password,
                  'type': item.type
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'password': item.password,
                  'type': item.type
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'password': item.password,
                  'type': item.type
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            userName: row['userName'] as String?,
            password: row['password'] as String?,
            type: row['type'] as int?));
  }

  @override
  Future<User?> getUser(String userName, String password) async {
    return _queryAdapter.query(
        'SELECT * FROM User where userName = ?1 And password = ?2',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            userName: row['userName'] as String?,
            password: row['password'] as String?,
            type: row['type'] as int?),
        arguments: [userName, password]);
  }

  @override
  Future<User?> getUserByUsername(String userName) async {
    return _queryAdapter.query('SELECT * FROM User where userName = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            userName: row['userName'] as String?,
            password: row['password'] as String?,
            type: row['type'] as int?),
        arguments: [userName]);
  }

  @override
  Future<User?> getUserByType(int type) async {
    return _queryAdapter.query('SELECT * FROM User where type = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            userName: row['userName'] as String?,
            password: row['password'] as String?,
            type: row['type'] as int?),
        arguments: [type]);
  }

  @override
  Future<void> deleteAllUsers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM User');
  }

  @override
  Future<int> insertUser(User user) {
    return _userInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$InvoiceDAO extends InvoiceDAO {
  _$InvoiceDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _invoiceInsertionAdapter = InsertionAdapter(
            database,
            'Invoice',
            (Invoice item) => <String, Object?>{
                  'id': item.id,
                  'timeStamp': item.timeStamp,
                  'totalPrice': item.totalPrice,
                  'tax': item.tax
                }),
        _invoiceUpdateAdapter = UpdateAdapter(
            database,
            'Invoice',
            ['id'],
            (Invoice item) => <String, Object?>{
                  'id': item.id,
                  'timeStamp': item.timeStamp,
                  'totalPrice': item.totalPrice,
                  'tax': item.tax
                }),
        _invoiceDeletionAdapter = DeletionAdapter(
            database,
            'Invoice',
            ['id'],
            (Invoice item) => <String, Object?>{
                  'id': item.id,
                  'timeStamp': item.timeStamp,
                  'totalPrice': item.totalPrice,
                  'tax': item.tax
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Invoice> _invoiceInsertionAdapter;

  final UpdateAdapter<Invoice> _invoiceUpdateAdapter;

  final DeletionAdapter<Invoice> _invoiceDeletionAdapter;

  @override
  Future<List<Invoice>> getAllInvoices() async {
    return _queryAdapter.queryList('SELECT * FROM Invoice',
        mapper: (Map<String, Object?> row) => Invoice(
            id: row['id'] as int?,
            timeStamp: row['timeStamp'] as int?,
            totalPrice: row['totalPrice'] as double?,
            tax: row['tax'] as double?));
  }

  @override
  Future<List<Invoice>> getAllInvoicesBetweenDates(int from, int to) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Invoice where timeStamp >= ?1 and timeStamp <= ?2',
        mapper: (Map<String, Object?> row) => Invoice(
            id: row['id'] as int?,
            timeStamp: row['timeStamp'] as int?,
            totalPrice: row['totalPrice'] as double?,
            tax: row['tax'] as double?),
        arguments: [from, to]);
  }

  @override
  Future<Invoice?> getInvoice(int id) async {
    return _queryAdapter.query('SELECT * FROM Invoice where id = ?1',
        mapper: (Map<String, Object?> row) => Invoice(
            id: row['id'] as int?,
            timeStamp: row['timeStamp'] as int?,
            totalPrice: row['totalPrice'] as double?,
            tax: row['tax'] as double?),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllInvoices() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Invoice');
  }

  @override
  Future<int> insertInvoice(Invoice invoice) {
    return _invoiceInsertionAdapter.insertAndReturnId(
        invoice, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateInvoice(Invoice invoice) {
    return _invoiceUpdateAdapter.updateAndReturnChangedRows(
        invoice, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateAllInvoice(List<Invoice> invoices) {
    return _invoiceUpdateAdapter.updateListAndReturnChangedRows(
        invoices, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteInvoice(Invoice invoice) async {
    await _invoiceDeletionAdapter.delete(invoice);
  }
}

class _$InvoiceItemDAO extends InvoiceItemDAO {
  _$InvoiceItemDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _invoiceItemInsertionAdapter = InsertionAdapter(
            database,
            'InvoiceItem',
            (InvoiceItem item) => <String, Object?>{
                  'id': item.id,
                  'invoiceID': item.invoiceID,
                  'type': item.type,
                  'price': item.price,
                  'quantity': item.quantity
                }),
        _invoiceItemUpdateAdapter = UpdateAdapter(
            database,
            'InvoiceItem',
            ['id'],
            (InvoiceItem item) => <String, Object?>{
                  'id': item.id,
                  'invoiceID': item.invoiceID,
                  'type': item.type,
                  'price': item.price,
                  'quantity': item.quantity
                }),
        _invoiceItemDeletionAdapter = DeletionAdapter(
            database,
            'InvoiceItem',
            ['id'],
            (InvoiceItem item) => <String, Object?>{
                  'id': item.id,
                  'invoiceID': item.invoiceID,
                  'type': item.type,
                  'price': item.price,
                  'quantity': item.quantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<InvoiceItem> _invoiceItemInsertionAdapter;

  final UpdateAdapter<InvoiceItem> _invoiceItemUpdateAdapter;

  final DeletionAdapter<InvoiceItem> _invoiceItemDeletionAdapter;

  @override
  Future<List<InvoiceItem>> getAllInvoiceItems() async {
    return _queryAdapter.queryList('SELECT * FROM InvoiceItem',
        mapper: (Map<String, Object?> row) => InvoiceItem(
            id: row['id'] as int?,
            invoiceID: row['invoiceID'] as int?,
            type: row['type'] as String?,
            price: row['price'] as double?,
            quantity: row['quantity'] as double?));
  }

  @override
  Future<List<InvoiceItem>> getAllInvoiceItemsInvoiceID(int id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InvoiceItem where invoiceID = ?1',
        mapper: (Map<String, Object?> row) => InvoiceItem(
            id: row['id'] as int?,
            invoiceID: row['invoiceID'] as int?,
            type: row['type'] as String?,
            price: row['price'] as double?,
            quantity: row['quantity'] as double?),
        arguments: [id]);
  }

  @override
  Future<List<InvoiceItem>> getAllInvoiceItemsByItemID(int id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InvoiceItem where itemID = ?1',
        mapper: (Map<String, Object?> row) => InvoiceItem(
            id: row['id'] as int?,
            invoiceID: row['invoiceID'] as int?,
            type: row['type'] as String?,
            price: row['price'] as double?,
            quantity: row['quantity'] as double?),
        arguments: [id]);
  }

  @override
  Future<InvoiceItem?> getInvoiceItemByInvoiceItemID(int id) async {
    return _queryAdapter.query('SELECT * FROM InvoiceItem where id = ?1',
        mapper: (Map<String, Object?> row) => InvoiceItem(
            id: row['id'] as int?,
            invoiceID: row['invoiceID'] as int?,
            type: row['type'] as String?,
            price: row['price'] as double?,
            quantity: row['quantity'] as double?),
        arguments: [id]);
  }

  @override
  Future<InvoiceItem?> getInvoiceItemByItemID(int id) async {
    return _queryAdapter.query('SELECT * FROM InvoiceItem where itemID = ?1',
        mapper: (Map<String, Object?> row) => InvoiceItem(
            id: row['id'] as int?,
            invoiceID: row['invoiceID'] as int?,
            type: row['type'] as String?,
            price: row['price'] as double?,
            quantity: row['quantity'] as double?),
        arguments: [id]);
  }

  @override
  Future<InvoiceItem?> getInvoiceItemByInvoiceID(int id) async {
    return _queryAdapter.query('SELECT * FROM InvoiceItem where invoiceID = ?1',
        mapper: (Map<String, Object?> row) => InvoiceItem(
            id: row['id'] as int?,
            invoiceID: row['invoiceID'] as int?,
            type: row['type'] as String?,
            price: row['price'] as double?,
            quantity: row['quantity'] as double?),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllInvoiceItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM InvoiceItem');
  }

  @override
  Future<int> insertInvoiceItem(InvoiceItem invoiceItem) {
    return _invoiceItemInsertionAdapter.insertAndReturnId(
        invoiceItem, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertListInvoiceItem(List<InvoiceItem> invoiceItems) {
    return _invoiceItemInsertionAdapter.insertListAndReturnIds(
        invoiceItems, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateInvoiceItem(InvoiceItem invoiceItem) async {
    await _invoiceItemUpdateAdapter.update(
        invoiceItem, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteInvoiceItem(InvoiceItem invoiceItem) async {
    await _invoiceItemDeletionAdapter.delete(invoiceItem);
  }
}
