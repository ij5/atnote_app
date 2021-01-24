import 'package:flutter/material.dart';
import 'package:atnote/poem.dart';


class View extends StatefulWidget{
  final Poem poem;
  View({Key key, @required this.poem}):super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poem.title),
      ),
    );
  }
}