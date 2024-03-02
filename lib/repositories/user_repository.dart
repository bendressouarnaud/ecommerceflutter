import '../dao/dao_user.dart';
import '../models/user.dart';

class UserRepository {
  final userDao = UserDao();

  Future<int> getTotalUser() => userDao.getTotalUser();
  Future<User?> getConnectedUser() => userDao.getConnectedUser();
  Future<User?> findConnectedUser() => userDao.findConnectedUser(["idcli"
    ,"commune"
    ,"genre"
    ,"nom"
    ,"prenom"
    ,"email"
    ,"numero"
    ,"adresse"
    ,"fcmtoken"
    ,"pwd"
    ,"codeinvitation"
  ]);

  Future getCurrentUser() => userDao.getCurrentUser(["idcli","nom","prenom"]);

  Future getAllUsers(String query) => userDao.getUsers(["idcli","nom","prenom"], query);

  Future<int> insertUser(User user) => userDao.createUser(user);

  Future updateUser(User user) => userDao.updateUser(user);

  Future<int> deleteUserById(int id) => userDao.deleteUserById(id);

  //We are not going to use this in the demo
  //Future deleteAllUsers() => userDao.deleteAllTodos();
}