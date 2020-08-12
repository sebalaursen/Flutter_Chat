import 'dart:async';

import 'package:chat/bloc/UsersEvents.dart';
import 'package:chat/models/User.dart';
import 'package:chat/services/UserService.dart';

class UsersBloc {

  List<User> _users;
  UserService _userService = UserService();

  final _usersStateController = StreamController<List<User>>();
  StreamSink<List<User>> get _inUsers => _usersStateController.sink;
  Stream<List<User>> get users => _usersStateController.stream;

  final _usersEventController = StreamController<UsersEvent>();
  Sink<UsersEvent> get usersEventSink => _usersEventController.sink;

  UsersBloc() {
    _usersEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(UsersEvent event) async {
    if (event is SearchEvent) {
      var newUsers = await _userService.searchByUsername(event.query);
      if (newUsers.where((element) => element.username == event.myname).isNotEmpty) {
        newUsers.removeWhere((element) => element.username == event.myname);
      }
      _users = newUsers;
    }

    _inUsers.add(_users);
  }

  void dispose() {
    _usersStateController.close();
    _usersEventController.close();
  }
}