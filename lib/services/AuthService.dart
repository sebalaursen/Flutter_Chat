import 'package:chat/models/User.dart';
import 'package:chat/services/StorageService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> signIn(String email, String password) async {
    try {
      AuthResult res = await this.auth.signInWithEmailAndPassword(email: email, password: password);
      final username = await getUsername(email);
      final user = User(username, res.user.uid, email);
      StorageService.setUser(user);
      return user;
    } catch (e) {
      print('Log in failed $e');
      return null;
    }
  }

  Future<User> signUp(String email, String username, String password) async {
    try {
      AuthResult res = await this.auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = User(username, res.user.uid, email);
      StorageService.setUser(user);
      await updateUser(email, username);
      return user;
    } catch (e) {
      print('Sign up failed $e');
      return null;
    }
  }

  Future<void> updateUser(String email, String username) async {
    Map<String, String> user = {
      'Username' : username,
      'Email' : email
    };
    await Firestore.instance.collection('Users').add(user);
  }

  Future<String> getUsername(String email) async {
    final users = await Firestore.instance.collection('Users')
      .where('Email', isEqualTo: email)
      .getDocuments();
    return users.documents[0].data['Username'];
  }

  Future<void> signOut() async {
    try {
      return await this.auth.signOut();
    } catch (e) {
      print('Sign out failed $e');
    }
  }
}