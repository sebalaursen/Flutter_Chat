import 'package:chat/models/User.dart';
import 'package:chat/presentation/widgets/MessageCell.dart';
import 'package:chat/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:chat/presentation/widgets/TopBar.dart';

class ChatScreen extends StatefulWidget {

  final String chatId;
  final User me;
  final User user;

  ChatScreen({Key key, this.chatId, this.me, this.user}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  TextEditingController messageController = TextEditingController();
  UserService userService = UserService();

  Stream chatMessages;

  @override
  void initState() {
    super.initState();

    final stream = userService.loadChat(widget.chatId);
    setState(() {
      chatMessages = stream;
    });
  }

  _sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await userService.messageUser(widget.chatId, messageController.text);
      messageController.clear();
    }
  }

  Widget _messagesList() {
    return StreamBuilder(
      stream: chatMessages,
      builder: (context, snapshot) {
        if (snapshot?.data?.documents != null) {
          final documents = snapshot?.data?.documents;
          return ListView.builder(
            padding: EdgeInsets.only(top: 8),
            itemCount: documents?.length,
            itemBuilder: (context, index) {
              return MessageCell(message: documents[index]?.data['message'], 
                                 isMe: documents[index]?.data['sender'] == widget.me.username);
            }
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
      appBar: topBar(widget.user.username),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          child: Stack(
            children: [
              _messagesList(),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(
                  height: 70,
                  padding: EdgeInsets.only(left: 25, right: 25, top: 8),
                  color: Colors.grey[300],
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              style: TextStyle(color: Colors.green[900]),
                              decoration: InputDecoration(
                                hintText: 'Write a message...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          MaterialButton(
                            onPressed: _sendMessage,
                            color: Colors.green,
                            child: Text('Send', style: TextStyle(color: Colors.white, fontSize: 16)),
                            shape: StadiumBorder(),
                            height: 35,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ]),
        ),
      )
    );
  }
}