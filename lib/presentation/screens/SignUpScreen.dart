import 'package:chat/presentation/widgets/Button.dart';
import 'package:chat/presentation/widgets/TextFormInput.dart';
import 'package:chat/presentation/widgets/TopBar.dart';
import 'package:chat/services/AuthService.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthService authService = AuthService();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  _signUp() async {
    if(formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      final user = await authService.signUp(emailController.text, usernameController.text, passwordController.text);
      setState(() {
        isLoading = false;
      });
      if (user != null) {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(me: user)));
      }
    }
  }

  String _usernameValidation(String val) {
    return val.length < 4 ? "Wrong username format" : null;
  }

  String _emailValidate(String val) {
    return RegExp(r"^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,5})+$").hasMatch(val) ? null : 'Wrong email format';
  }

  String _passwordValidate(String val) {
    return val.length < 6 ? "Password too short" : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar('Sign Up'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Form(
              key: this.formKey, 
              child: Column(children: [
                textFormInput('Email', emailController, this._emailValidate),
                SizedBox(height: 15),
                textFormInput('Username', usernameController, this._usernameValidation),
                SizedBox(height: 15),
                textFormInput('Password', passwordController, this._passwordValidate, true),
                SizedBox(height: 50),
              ])
            ),
            button('Continue', onPressed: this._signUp),
          ],
        ),
      )
    );
  }
}