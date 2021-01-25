import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:screen/screen.dart';
import 'db.dart';
import 'home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox('poems');
  runApp(App());
  Screen.keepOn(true);
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "@note",
      home: Home(),
    );
  }
}

