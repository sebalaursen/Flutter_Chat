import 'package:flutter/material.dart';

Widget textFormInput(String name, TextEditingController controller, dynamic Function(String) validator, [ bool isSecure = false ]) {
  return TextFormField(
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: name,
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
    ),
    controller: controller,
    validator: validator,
    obscureText: isSecure,
  );
}