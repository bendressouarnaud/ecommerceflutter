

import '../database/database.dart';
import '../models/article.dart';

class ArticleDao {
  final dbProvider = DatabaseHelper.instance;

  //Adds new Todo records
  Future<int> create(Article dt) async {
    final db = await dbProvider.database;
    var result = db.insert("article", dt.toJson());
    return result;
  }

  // Get ACHATS :
  Future<List<Article>> findAll(List<String> columns) async{
    final db = await dbProvider.database;
    late List<Map<String, dynamic>> result;
    result = await db.query("article",
        columns: columns);
    List<Article> liste = result.isNotEmpty
        ? result.map((item) => Article.fromJson(item)).toList()
        : [];
    return liste;
  }

  //We are not going to use this in the demo
  Future<int> deleteAll() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      "article",
    );
    return result;
  }

  Future<int> update(Article dt) async {
    final db = await dbProvider.database;
    var result = await db.update("article", dt.toJson(),
        where: "idart = ?", whereArgs: [dt.idart]);
    return result;
  }
}