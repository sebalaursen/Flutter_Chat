import 'package:chat/models/User.dart';
import 'package:flutter/material.dart';

class MessageCell extends StatelessWidget {
  
  final String message;
  final bool isMe;

  MessageCell({Key key, this.message, this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6, bottom: 6, right: isMe ? 5 : 50, left: isMe ? 50 : 5),
      width: MediaQuery.of(context).size.width,
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isMe ? Colors.green : Colors.grey,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(isMe ? -2 : 2, 3),
            ),
          ],
          borderRadius: isMe ? BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ) : BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )
        ),
        child: Text(message, style: TextStyle(color: Colors.white, fontSize: 16))
      )
    );
  }
}