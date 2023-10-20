

import 'package:newecommerce/dao/dao_achat.dart';

import '../models/achat.dart';

class AchatRepository {
  final tbDao = AchatDao();

  Future getListAchat() => tbDao.getListAchat(["idach","idart","actif"]);

  Future<List<Achat>> findAllAchatByActif(String query) => tbDao.findAllAchatByActif(["idach","idart","actif"], query);

  Future<int> insertAchat(Achat dt) => tbDao.createAchat(dt);

  Future updateAchat(Achat dt) => tbDao.updateAchat(dt);

  Future deleteAchatById(int id) => tbDao.deleteAchatById(id);

//We are not going to use this in the demo
//Future deleteAllUsers() => userDao.deleteAllTodos();
}