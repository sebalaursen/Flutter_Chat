import 'package:chat/models/User.dart';
import 'package:flutter/material.dart';

class ChatCell extends StatelessWidget {
  
  final String user;
  final String chatId;
  final void Function(String, String) onChat;

  ChatCell({Key key, this.user, this.chatId, this.onChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChat(chatId, user),
      child: Container(
        padding: EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text(user.substring(0,1).toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 8),
            Expanded(child: Text(user, style: TextStyle(fontSize: 16, color: Colors.black))),
            Container(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                onPressed: () => onChat(chatId, user),
                color: Colors.green,
                child: Text('Chat', style: TextStyle(color: Colors.white, fontSize: 16)),
                shape: StadiumBorder(),
                height: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}