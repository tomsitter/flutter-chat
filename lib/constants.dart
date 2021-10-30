import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightYellow = Color(0xFFFFCE71);
  static const Color darkYellow = Color(0xFFFFB357);
  static const Color poleBrown = Color(0xFFCE857A);
  static const Color cheekPink = Color(0xFFFF8E9E);

  static const sendButtonTextStyle = TextStyle(
    color: cheekPink,
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );

  static const messageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: 'Type your message here...',
    border: InputBorder.none,
  );

  static const messageContainerDecoration = BoxDecoration(
    border: Border(
      top: BorderSide(color: poleBrown, width: 2.0),
    ),
  );

  static const textFieldDecoration = InputDecoration(
    hintText: '',
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(32.0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: darkYellow, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: darkYellow, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
}
