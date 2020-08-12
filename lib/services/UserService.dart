import 'package:chat/models/User.dart';
import 'package:chat/services/StorageService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {

  Future<List<User>> searchByUsername(String query) async {
    final res = await Firestore.instance.collection('Users')
      .where('Username', isEqualTo: query)
      .getDocuments();

    List<User> list = [];
    res.documents.forEach((element) {
      list.add(User(element.data['Username'], element.documentID, element.data['Email']));
    });
    return list;
  }

  Future<String> startChat(String user1, String user2) async {
    List<String> users = [user1, user2];
    String chatId = getChatId(user1, user2);
    Map<String, dynamic> data = {
      'users' : users,
      'chatId' : chatId,
    };
    await Firestore.instance.collection('Chats')
      .document(chatId).setData(data);
    return chatId;
  }

  Stream<QuerySnapshot> loadChat(String chatId) {
    return Firestore.instance.collection('Chats')
      .document(chatId)
      .collection('Messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
  }

  Stream<QuerySnapshot> loadChats(String username) {
    return Firestore.instance.collection('Chats')
      .where('users', arrayContains: username)
      .snapshots(); 
  }

  Future<void> messageUser(String chatId, String message) async {
    User user = await StorageService.getUser();
    Map<String, dynamic> data = {
      'message' : message,
      'sender' : user.username,
      'timestamp' : DateTime.now().millisecondsSinceEpoch
    };
    await Firestore.instance.collection('Chats')
      .document(chatId)
      .collection('Messages')
      .add(data);
  }

  String getChatId(String user1, String user2) {
    if (user1.compareTo(user2) == -1) {
      return user1 + '_' + user2;
    } else {
      return user2 + '_' + user1;
    }
  }
}