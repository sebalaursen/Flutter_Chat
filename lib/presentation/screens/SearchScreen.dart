import 'dart:async';

import 'package:chat/models/User.dart';
import 'package:chat/presentation/screens/ChatScreen.dart';
import 'package:chat/presentation/widgets/SearchUserCell.dart';
import 'package:chat/services/StorageService.dart';
import 'package:chat/services/UserService.dart';
import 'package:flutter/material.dart';

import 'package:chat/presentation/widgets/TopBar.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = TextEditingController();
  UserService userService = UserService();

  var isNavigating = false;
  var users = [];

  _search(String query) async {
    Timer(Duration(milliseconds: 500), () async {
      if (query == this.searchController.text) {
        final newUsers = await userService.searchByUsername(query);
        setState(() {
          users = newUsers;
        });
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
    return users.isNotEmpty ? ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        return SearchUserCell(user: users[index], onMessage: startChat);
      }
    ) : Container();
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
}