import 'package:flutter/material.dart';

class Note {
  String title;
  String content;

  Note({
    required this.title,
    required this.content,
  });
}

class User {
  String userName;
  String password;
  String email;

  User({
    required this.userName,
    required this.password,
    required this.email,
  });
}

Color back = Colors.black;
Color txt = Colors.white;
Color butt = Colors.orange;

void invertColors(){
  back = back == Colors.black? Colors.white : Colors.black;
  butt = butt == Colors.orange? Colors.blue : Colors.orange;
  txt = txt == Colors.white? Colors.black : Colors.white;
}