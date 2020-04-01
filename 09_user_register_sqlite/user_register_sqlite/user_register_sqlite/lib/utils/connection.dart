import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDB {
  static final SqliteDB _singleton = new SqliteDB._internal();
  static Database _database;

  factory SqliteDB() => _singleton;

  SqliteDB._internal();


  static Future<Database> connect() async {
    if (_database!=null) return _database;
    
    var databasePath = await getDatabasesPath();
    final String path = join(databasePath, 'store.db');
    _database = await openDatabase(path, version: 1, onCreate: (Database db, int version) {
      db.execute('''
        CREATE TABLE user (
          id INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT,
          enabled INTEGER
        );
      ''');
    });

    return _database;
  }

}