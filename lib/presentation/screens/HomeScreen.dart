import 'package:chat/models/User.dart';
import 'package:chat/presentation/screens/ChatScreen.dart';
import 'package:chat/presentation/screens/SearchScreen.dart';
import 'package:chat/presentation/screens/SignInScreen.dart';
import 'package:chat/presentation/widgets/ChatCell.dart';
import 'package:chat/services/StorageService.dart';
import 'package:chat/services/UserService.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  final User me;

  HomeScreen({ Key key, this.me }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  UserService userService = UserService();
  Stream chatsStream;

  @override
  void initState() {
    super.initState();

    final stream = userService.loadChats(widget.me.username);
    setState(() {
      chatsStream = stream;
    });
  }

  _chat(String chatId, String username) {
    Navigator.push(context, MaterialPageRoute(builder: 
      (context) => ChatScreen(chatId: chatId, me: widget.me, user: User(username, '', ''))
    ));
  }

  _logout() async {
    await StorageService.clearUser();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  _search() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(me: widget.me)));
  }

  Widget _chatsList() {
    return StreamBuilder(
      stream: chatsStream,
      builder: (context, snapshot) {
        if (snapshot?.data?.documents != null && snapshot?.data != null) {
          final documents = snapshot?.data?.documents;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder:  (context, index) {
              final List<dynamic> users = documents[index]?.data['users'];
              final user = users.where((element) => element != widget.me.username);
              return ChatCell(user: user?.first, chatId: documents[index]?.data['chatId'], onChat: _chat);
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          GestureDetector(
            onTap: this._logout,
            child: Center(
              child: Container(
                child: Text('Log out', style: TextStyle(fontSize: 18, decoration: TextDecoration.underline)),
                padding: EdgeInsets.only(right: 10),
              ),
            ),
          ),
          Container(child: IconButton(icon: Icon(Icons.search), onPressed: this._search), padding: EdgeInsets.only(top: 1),),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(child: _chatsList(), margin: EdgeInsets.only(top: 5))
      ),
    );
  }
}