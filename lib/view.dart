import 'package:flutter/material.dart';
import 'package:atnote/poem.dart';
import 'package:zefyr/zefyr.dart';


class View extends StatefulWidget{
  Map poem;

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Text("Hello"),
      ),
    );
  }
}