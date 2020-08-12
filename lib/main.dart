import 'package:chat/models/User.dart';
import 'package:chat/presentation/screens/HomeScreen.dart';
import 'package:chat/presentation/screens/SignInScreen.dart';
import 'package:chat/services/StorageService.dart';
import 'package:flutter/material.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final user = await checkUser();
  final isLogged = user != null;
  runApp(MyApp(isLoggedIn: isLogged, me: user));
}

class MyApp extends StatelessWidget {

  final bool isLoggedIn;
  final User me;

  MyApp({Key key, this.isLoggedIn, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? HomeScreen(me: me) : SignInScreen(),
    );
  }
}

Future<User> checkUser() async {
  final user = await StorageService.getUser();
  if (user.id != null) {
    return user;
  } else {
    return null;
  }
}