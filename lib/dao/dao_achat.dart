import 'dart:async';

import '../database/database.dart';
import '../models/achat.dart';

class AchatDao {
  final dbProvider = DatabaseHelper.instance;

  //Adds new Todo records
  Future<int> createAchat(Achat dt) async {
    final db = await dbProvider.database;
    //var result = db.insert("achat", dt.toJson());
    var result = db.rawInsert('INSERT INTO achat(idart, actif) values("${dt.idart}", "${dt.actif}")');// .insert("achat", dt.toJson());
    return result;
  }

  // Get ACHATS :
  Future<List<Achat>> getListAchat(List<String> columns) async{
    final db = await dbProvider.database;
    late List<Map<String, dynamic>> result;
    result = await db.query("achat",
        columns: columns);
    List<Achat> liste = result.isNotEmpty
        ? result.map((item) => Achat.fromJson(item)).toList()
        : [];
    return liste;
  }

  //Get All ACHATS
  Future<List<Achat>> findAllAchatByActif(List<String> columns, String query) async {
    final db = await dbProvider.database;
    late List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty) {
        result = await db.query("achat",
            columns: columns,
            where: 'actif = ?',
            whereArgs: [query]);
      }
    } else {
      result = await db.query("achat", columns: columns);
    }

    List<Achat> liste = result.isNotEmpty
        ? result.map((item) => Achat.fromJson(item)).toList()
        : [];
    return liste;
  }

  //Get All ACHATS by 'idart' and 'actif'
  Future<List<Achat>> findAllAchatByIdartAndActif(List<String> columns, int idart, int actif) async {
    final db = await dbProvider.database;
    late List<Map<String, dynamic>> result;
    result = await db.query("achat",
        columns: columns,
        where: 'actif = ? and idart = ?',
        whereArgs: [actif, idart]);

    List<Achat> liste = result.isNotEmpty
        ? result.map((item) => Achat.fromJson(item)).toList()
        : [];
    return liste;
  }

  //Update Achat
  Future<int> updateAchat(Achat dt) async {
    final db = await dbProvider.database;
    var result = await db.update("achat", dt.toJson(),
        where: "idach = ?", whereArgs: [dt.idach]);
    return result;
  }

  //Delete Achat
  Future<int> deleteAchatById(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete("achat", where: 'idach = ?', whereArgs: [id]);
    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllAchats() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      "achat",
    );
    return result;
  }
}