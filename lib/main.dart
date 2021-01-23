import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'home.dart';

void main() {
  runApp(App());
  Screen.keepOn(true);
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

