import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'home.dart';
import 'package:atnote/db.dart';

void main() {
  runApp(App());
  Screen.keepOn(true);
  initDB();
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "@note",
      home: Home(),
    );
  }
}

