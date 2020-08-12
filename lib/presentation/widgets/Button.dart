import 'package:flutter/material.dart';

_default() => null;

Widget button(String name, { Color color = Colors.green, void Function() onPressed = _default, }) {
  return MaterialButton(
    onPressed: onPressed,
    color: color,
    child: Text(name, style: TextStyle(color: Colors.white, fontSize: 20)),
    shape: StadiumBorder(),
    minWidth: 400,
    height: 50,
  );
}