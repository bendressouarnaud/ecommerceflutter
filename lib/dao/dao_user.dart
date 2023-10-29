import 'dart:async';

import '../database/database.dart';
import '../models/user.dart';

class UserDao {
  final dbProvider = DatabaseHelper.instance;

  //Adds new Todo records
  Future<int> createUser(User user) async {
    final db = await dbProvider.database;
    var result = db.insert("user", user.toDatabaseJson());
    return result;
  }

  Future<User?> getConnectedUser() async {
    final db = await dbProvider.database;
    var results = await db.rawQuery('SELECT * FROM user');

    if (results.isNotEmpty) {
      return User.fromDatabaseJson(results.first);
    }

    return null;
  }

  // Get ONE USER :
  Future<List<User>> getCurrentUser(List<String> columns) async{
    final db = await dbProvider.database;
    late List<Map<String, dynamic>> result;
    result = await db.query("user",
        columns: columns);
    List<User> users = result.isNotEmpty
        ? result.map((item) => User.fromDatabaseJson(item)).toList()
        : [];
    return users;
  }

  //Get All Todo items
  //Searches if query string was passed
  Future<List<User>> getUsers(List<String> columns, String query) async {
    final db = await dbProvider.database;
    late List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty) {
        result = await db.query("user",
            columns: columns,
            where: 'nom LIKE ?',
            whereArgs: ["%$query%"]);
      }
    } else {
      result = await db.query("user", columns: columns);
    }

    List<User> users = result.isNotEmpty
        ? result.map((item) => User.fromDatabaseJson(item)).toList()
        : [];
    return users;
  }

  //Update Todo record
  Future<int> updateUser(User todo) async {
    final db = await dbProvider.database;
    var result = await db.update("user", todo.toDatabaseJson(),
        where: "idcli = ?", whereArgs: [todo.idcli]);
    return result;
  }

  //Delete Todo records
  Future<int> deleteUserById(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete("user", where: 'idcli = ?', whereArgs: [id]);
    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllUsers() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      "user",
    );
    return result;
  }
}