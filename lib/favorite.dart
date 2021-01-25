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
            itemCount: snapshot.data.get('file')==null?0:snapshot.data.get('file').length,
            itemBuilder: (BuildContext context, int i){
              var file = File(snapshot.data.get('file')[i]);
              var content = jsonDecode(file.readAsStringSync());
              if(content[0]['trash']=="true"){
                return SizedBox.shrink();
              }
              if(content[0]['heart']=="false"){
                return SizedBox.shrink();
              }
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction){
                  content[0]['trash'] = "true";
                  file.writeAsString(jsonEncode(content));
                  Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("Moved to trash.")));
                },
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>View()));
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
                      Positioned(
                        child: content[0]['heart']=="true"
                            ?InkWell(
                          child: Icon(Icons.favorite, color: Colors.red,),
                          onTap: (){
                            setState(() {
                              content[0]['heart'] = "false";
                            });
                            file.writeAsString(jsonEncode(content));
                          },
                        )
                            :InkWell(
                          child: Icon(Icons.favorite_outline),
                          onTap: (){
                            setState(() {
                              content[0]['heart'] = "true";
                            });
                            file.writeAsString(jsonEncode(content));
                          },
                        ),
                        right: 30,
                        bottom: 25,
                      ),
                    ],
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