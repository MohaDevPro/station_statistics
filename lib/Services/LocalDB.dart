import '../Database/database/database.dart';

class LocalDB {
  static final LocalDB _instance = LocalDB._const();
  factory LocalDB() {
    return _instance;
  }

  LocalDB._const();

  late AppDatabase appDatabaseCache;
  init() async {
    appDatabaseCache =
        await $FloorAppDatabase.databaseBuilder('database.db').build();
  }
}
