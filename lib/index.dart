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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  initPoem()async{
    return await Hive.openBox('poems');
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: poems==null?initPoem():poems,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            itemCount: snapshot.data.get('file').length,
            itemBuilder: (BuildContext context, int i){
              var file = File(snapshot.data.get('file')[i]);
              var content = jsonDecode(file.readAsStringSync());
              if(content[0]['trash']=="true"){
                return null;
              }
              return Dismissible(
                key: Key(snapshot.data.get('file')[i].toString()),
                onDismissed: (direction){
                  setState(() {
                    snapshot.data.get('file').removeAt(i);
                  });
                  Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("Moved to trash.")));
                },
                child: Container(
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
                    child: Text(content[0]['title']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
