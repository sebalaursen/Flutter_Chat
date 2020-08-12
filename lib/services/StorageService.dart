import 'package:chat/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

final usernameKey = 'username';
final emailKey = 'email';
final idKey = 'id';

class StorageService {
  
  static Future<void> setUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(usernameKey, user.username);
    prefs.setString(emailKey, user.email);
    prefs.setString(idKey, user.id);
  }

  static Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(usernameKey);
    final email = prefs.getString(emailKey);
    final id = prefs.getString(idKey);

    return User(username, id, email);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(usernameKey);
    prefs.remove(emailKey);
    prefs.remove(idKey);
  }
}