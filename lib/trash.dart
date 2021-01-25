import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:atnote/view.dart';

class Favorite extends StatefulWidget{
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  var poems;

  initPoem()async{
    poems = await Hive.openBox('poems');
    return poems;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trash"),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
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
                return Dismissible(
                  key: Key(snapshot.data.get('file')[i].toString()),
                  onDismissed: (direction){
                    file.delete();
                    snapshot.data.get('file').removeAt(i);
                    poems.put('file', snapshot.data.get('file'));
                    Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("DELETED.")));
                  },
                  child: GestureDetector(
                    onTap: (){
                      
                    },
                    child: Stack(
                      children: [
                        Container(
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
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}