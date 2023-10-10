import 'dart:async';

import 'package:newecommerce/repositories/user_repository.dart';

import '../models/user.dart';

class UserBloc {
  //Get instance of the Repository
  final _userRepository = UserRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _todoController = StreamController<List<User>>.broadcast();
  get todos => _todoController.stream;

  UserBloc() {
    getCurrentUser();
  }

  getCurrentUser() async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _todoController.sink.add(await _userRepository.getCurrentUser());
  }

  getUsers(String query) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _todoController.sink.add(await _userRepository.getAllUsers(query));
  }

  addUser(User user) async {
    await _userRepository.insertUser(user);
    getCurrentUser();
  }

  updateTodo(User user) async {
    await _userRepository.updateUser(user);
    getCurrentUser();
  }

  deleteTodoById(int id) async {
    _userRepository.deleteUserById(id);
    getCurrentUser();
  }

  dispose() {
    _todoController.close();
  }
}