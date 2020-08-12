import 'package:chat/presentation/screens/HomeScreen.dart';
import 'package:chat/presentation/screens/SignUpScreen.dart';
import 'package:chat/presentation/widgets/Button.dart';
import 'package:chat/presentation/widgets/TextFormInput.dart';
import 'package:chat/presentation/widgets/TopBar.dart';
import 'package:chat/services/AuthService.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthService authService = AuthService();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  _signIn() async {
    if(formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      final user = await authService.signIn(emailController.text, passwordController.text);
      setState(() {
        isLoading = false;
      });
      if (user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(me: user)));
      }
    }
  }

  _signUp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  String _emailValidate(String val) {
    return RegExp(r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,5})+$').hasMatch(val) ? null : 'Wrong email format';
  }

  String _passwordValidate(String val) {
    return val.isEmpty || val.length < 6 ? "Password too short" : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar('Sign In'),
      body: isLoading ? Center(child: CircularProgressIndicator()) : Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Form(
              key: formKey, 
              child: Column(children: [
                textFormInput('Email', emailController, this._emailValidate),
                SizedBox(height: 15),
                textFormInput('Password', passwordController, this._passwordValidate, true),
                SizedBox(height: 50),
              ])
            ),
            button('Sign In', onPressed: this._signIn),
            SizedBox(height: 15),
            button('Sign Up', color: Colors.grey, onPressed: this._signUp),
          ],
        ),
      )
    );
  }
}