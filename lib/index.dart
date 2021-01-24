import 'package:flutter/material.dart';
import 'package:atnote/db.dart';

class Index extends StatefulWidget{
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  var poem;
  void initState(){
    super.initState();
    poem = getPoems();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: poem.length,
        itemBuilder: (BuildContext context, int i){
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffd6d6d6), width: 1),
            ),
            child: Center(
              child: Text(poem[i].title),
            ),
          );
        },
      ),
    );
  }
}