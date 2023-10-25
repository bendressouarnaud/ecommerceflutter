
import 'package:newecommerce/dao/dao_article.dart';

import '../models/article.dart';

class ArticleRepository {
  final artDao = ArticleDao();

  //
  Future<int> insertAchat(Article dt) => artDao.create(dt);
  Future<List<Article>> findAll() => artDao.findAll(["idart","iddet","prix","reduction","note","articlerestant","libelle","lienweb"]);
  Future<int> deleteAll() => artDao.deleteAll();
  Future<int> update(Article dt) => artDao.update(dt);

}