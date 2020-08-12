import 'dart:async';

import 'package:chat/bloc/UsersBloc.dart';
import 'package:chat/bloc/UsersEvents.dart';
import 'package:chat/models/User.dart';
import 'package:chat/presentation/screens/ChatScreen.dart';
import 'package:chat/presentation/widgets/SearchUserCell.dart';
import 'package:chat/services/StorageService.dart';
import 'package:chat/services/UserService.dart';
import 'package:flutter/material.dart';

import 'package:chat/presentation/widgets/TopBar.dart';

class SearchScreen extends StatefulWidget {

  final User me;

  SearchScreen({ Key key, this.me }) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = TextEditingController();
  UserService userService = UserService();

  final _bloc = UsersBloc();
  var isNavigating = false;

  _search(String query) async {
    Timer(Duration(milliseconds: 500), () async {
      if (query == this.searchController.text) {
        print('go search');
        _bloc.usersEventSink.add(SearchEvent(query, widget.me.username));
      }
    });
  }

  startChat(User user) async {
    if (!isNavigating) {
      isNavigating = true;
      User user2 = await StorageService.getUser();
      var chatId = await userService.startChat(user.username, user2.username);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatId: chatId, me: user2, user: user)));
      isNavigating = false;
    }
  }

  Widget _searchList() {
    return StreamBuilder<List<User>>(
      stream: _bloc.users,
      initialData: [],
      builder: (context, AsyncSnapshot<List<User>> snapshot) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return SearchUserCell(user: snapshot.data[index], onMessage: startChat);
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar('Search'),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                  Expanded(child: TextField(
                    controller: searchController,
                    onChanged: _search,
                    decoration: InputDecoration(
                      hintText: 'Search user',
                    ),
                  )),
                  Container(child: Icon(Icons.search), padding: EdgeInsets.only(top: 10, left: 5))
                  ],
                ),
                SizedBox(height: 25),
                _searchList(),
              ],
            ),
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}