import 'package:chat/models/User.dart';
import 'package:flutter/material.dart';

class SearchUserCell extends StatelessWidget {
  
  final User user;
  final void Function(User) onMessage;

  SearchUserCell({Key key, this.user, this.onMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.username, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Text(user.email),
                ],
              ),
              Spacer(),
              Container(
                child: MaterialButton(
                  onPressed: () => onMessage(user),
                  color: Colors.green,
                  child: Text('Send a Message', style: TextStyle(color: Colors.white, fontSize: 16)),
                  shape: StadiumBorder(),
                  height: 35,
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
          SizedBox(height: 1, child: Container(color: Colors.grey)),
        ],
      ),
    );
  }
}