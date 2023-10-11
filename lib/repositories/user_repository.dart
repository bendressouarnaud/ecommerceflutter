import '../dao/dao_user.dart';
import '../models/user.dart';

class UserRepository {
  final userDao = UserDao();

  Future getCurrentUser() => userDao.getCurrentUser(["idcli","nom","prenom"]);

  Future getAllUsers(String query) => userDao.getUsers(["idcli","nom","prenom"], query);

  Future insertUser(User user) => userDao.createUser(user);

  Future updateUser(User user) => userDao.updateUser(user);

  Future deleteUserById(int id) => userDao.deleteUserById(id);

  //We are not going to use this in the demo
  //Future deleteAllUsers() => userDao.deleteAllTodos();
}