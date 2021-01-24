import 'package:flutter/material.dart';

class Poem{
  final int id;
  final String title;
  final String date;
  final String file;
  final String heart;

  Poem({this.id, this.title, this.date, this.file, this.heart});

  Map<String, dynamic> toMap(){
    return {
      'id': this.id,
      'title': this.title,
      'date': this.date,
      'file': this.file,
      'heart': this.heart,
    };
  }
}

class View extends StatefulWidget{
  final Poem poem;
  View({Key key, @required this.poem}):super(key: key);

  @override
  _ViewState createState() => _ViewState(poem: this.poem);
}

class _ViewState extends State<View> {
  Poem poem;
  _ViewState({Key key, @required this.poem}):super(key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),

      ),
    );
  }
}