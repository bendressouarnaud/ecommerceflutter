import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "fluttercommerce.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;


  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database ;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE user (idcli INTEGER PRIMARY KEY,commune INTEGER,genre INTEGER,nom TEXT,prenom TEXT,email TEXT,numero TEXT,adresse TEXT,fcmtoken TEXT,pwd TEXT)');
    //await db.execute('CREATE TABLE user (id INTEGER PRIMARY KEY,name TEXT NOT NULL,pwd TEXT NOT NULL)');
  }

  // Database helper methods:
  /*Future<int> insert(User user) async {
    Database db = await database;
    int id = await db.insert('user', user.toMap());
    return id;
  }

  Future<User?> queryWord(int id) async {
    Database db = await database;
    List<Map> maps = await db.query('user',
        columns: ['id', 'name', 'pwd'],
        where: 'id = ?',
        whereArgs: [id]);
    // Browse :
    if (maps.length > 0) {
      //return User.fromMap(maps.first);
      return User(
          id: maps[0]['id'],
          name: maps[0]['name'],
          pwd: maps[0]['pwd']
      );
    }
    return null;
  }

  // Look for specific user  :
  Future<User?> authenticateUser(String id, String pwd) async {
    Database db = await database;
    List<Map> maps = await db.query('user',
        columns: ['id', 'name', 'pwd'],
        where: 'name = ? and pwd = ?',
        whereArgs: [id, pwd]);
    // Browse :
    if (maps.isNotEmpty) {
      //return User.fromMap(maps.first);
      return User(
          id: maps[0]['id'],
          name: maps[0]['name'],
          pwd: maps[0]['pwd']
      );
    }
    return null;
  }

  // Look for specific user  :
  Future<User?> getLocalUser() async {
    Database db = await database;
    List<Map> maps = await db.query('user',
        columns: ['id', 'name', 'pwd']);
    // Browse :
    if (maps.isNotEmpty) {
      //return User.fromMap(maps.first);
      return User(
          id: maps[0]['id'],
          name: maps[0]['name'],
          pwd: maps[0]['pwd']
      );
    }
    return null;
  }*/

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}