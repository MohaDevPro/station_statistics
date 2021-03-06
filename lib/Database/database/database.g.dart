// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

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

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

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
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
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
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDAO _userDAOInstance;

  InvoiceDAO _invoiceDAOInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
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
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER, `userName` TEXT, `password` TEXT, `type` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Invoice` (`id` INTEGER, `timeStamp` INTEGER, `type` TEXT, `totalPrice` REAL, `price` REAL, `quantity` REAL, `isSaved` INTEGER, PRIMARY KEY (`id`))');

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
}

class _$UserDAO extends UserDAO {
  _$UserDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'userName': item.userName,
                  'password': item.password,
                  'type': item.type
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'userName': item.userName,
                  'password': item.password,
                  'type': item.type
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, dynamic>{
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
        mapper: (Map<String, dynamic> row) => User(
            id: row['id'] as int,
            userName: row['userName'] as String,
            password: row['password'] as String,
            type: row['type'] as int));
  }

  @override
  Future<User> getUser(String userName, String password) async {
    return _queryAdapter.query(
        'SELECT * FROM User where userName = ? And password = ?',
        arguments: <dynamic>[userName, password],
        mapper: (Map<String, dynamic> row) => User(
            id: row['id'] as int,
            userName: row['userName'] as String,
            password: row['password'] as String,
            type: row['type'] as int));
  }

  @override
  Future<User> getUserByUsername(String userName) async {
    return _queryAdapter.query('SELECT * FROM User where userName = ?',
        arguments: <dynamic>[userName],
        mapper: (Map<String, dynamic> row) => User(
            id: row['id'] as int,
            userName: row['userName'] as String,
            password: row['password'] as String,
            type: row['type'] as int));
  }

  @override
  Future<User> getUserByType(int type) async {
    return _queryAdapter.query('SELECT * FROM User where type = ?',
        arguments: <dynamic>[type],
        mapper: (Map<String, dynamic> row) => User(
            id: row['id'] as int,
            userName: row['userName'] as String,
            password: row['password'] as String,
            type: row['type'] as int));
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
            (Invoice item) => <String, dynamic>{
                  'id': item.id,
                  'timeStamp': item.timeStamp,
                  'type': item.type,
                  'totalPrice': item.totalPrice,
                  'price': item.price,
                  'quantity': item.quantity,
                  'isSaved':
                      item.isSaved == null ? null : (item.isSaved ? 1 : 0)
                }),
        _invoiceUpdateAdapter = UpdateAdapter(
            database,
            'Invoice',
            ['id'],
            (Invoice item) => <String, dynamic>{
                  'id': item.id,
                  'timeStamp': item.timeStamp,
                  'type': item.type,
                  'totalPrice': item.totalPrice,
                  'price': item.price,
                  'quantity': item.quantity,
                  'isSaved':
                      item.isSaved == null ? null : (item.isSaved ? 1 : 0)
                }),
        _invoiceDeletionAdapter = DeletionAdapter(
            database,
            'Invoice',
            ['id'],
            (Invoice item) => <String, dynamic>{
                  'id': item.id,
                  'timeStamp': item.timeStamp,
                  'type': item.type,
                  'totalPrice': item.totalPrice,
                  'price': item.price,
                  'quantity': item.quantity,
                  'isSaved':
                      item.isSaved == null ? null : (item.isSaved ? 1 : 0)
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
        mapper: (Map<String, dynamic> row) => Invoice(
            id: row['id'] as int,
            timeStamp: row['timeStamp'] as int,
            type: row['type'] as String,
            totalPrice: row['totalPrice'] as double,
            price: row['price'] as double,
            quantity: row['quantity'] as double,
            isSaved:
                row['isSaved'] == null ? null : (row['isSaved'] as int) != 0));
  }

  @override
  Future<List<Invoice>> getAllInvoicesBetweenDates(int from, int to) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Invoice where timeStamp >= ? and timeStamp <= ?',
        arguments: <dynamic>[from, to],
        mapper: (Map<String, dynamic> row) => Invoice(
            id: row['id'] as int,
            timeStamp: row['timeStamp'] as int,
            type: row['type'] as String,
            totalPrice: row['totalPrice'] as double,
            price: row['price'] as double,
            quantity: row['quantity'] as double,
            isSaved:
                row['isSaved'] == null ? null : (row['isSaved'] as int) != 0));
  }

  @override
  Future<Invoice> getInvoice(int id) async {
    return _queryAdapter.query('SELECT * FROM Invoice where id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => Invoice(
            id: row['id'] as int,
            timeStamp: row['timeStamp'] as int,
            type: row['type'] as String,
            totalPrice: row['totalPrice'] as double,
            price: row['price'] as double,
            quantity: row['quantity'] as double,
            isSaved:
                row['isSaved'] == null ? null : (row['isSaved'] as int) != 0));
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
