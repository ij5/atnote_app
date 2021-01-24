import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:atnote/db.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class Index extends StatefulWidget {
  @override
  IndexState createState() => IndexState();
}

class IndexState extends State<Index> {
  var poems;
  void initState() {
    super.initState();
    initPoem();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  initPoem()async{
    poems = await Hive.openBox('poems');
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        itemCount: poems==null?0:poems.get('file').length,
        itemBuilder: (BuildContext context, int i){
          var file = File(poems.get('file')[i]);
          print(file.readAsStringSync());
          return Container(
            margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xffd6d6d6), width: 0),
              boxShadow: [BoxShadow(
                  color: Colors.black12,
                  offset: Offset(7, 7),
                  blurRadius: 10,
                  spreadRadius: 0
              ),],
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Center(
              child: Text(file.readAsStringSync()),
            ),
          );
        },
      ),
    );
  }
}
