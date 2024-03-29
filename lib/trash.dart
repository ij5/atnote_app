import 'dart:convert';
import 'dart:io';
import 'package:atnote/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:atnote/view.dart';

class Trash extends StatefulWidget{
  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  var poems;

  initPoem()async{
    poems = await Hive.openBox('poems');
    return poems;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Get.back();
        return Future(()=>false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Trash"),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (){
              Get.back();
            },
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.delete_forever),
          //     onPressed: ()async{
          //       final p = await initPoem();
          //       final poemsList = p.get('file');
          //       var content;
          //       var file;
          //       poemsList.forEach((poem){
          //         file = File(poem);
          //         content = jsonDecode(file.readAsStringSync());
          //         if(content[0]['trash']=="false"){
          //           return;
          //         }
          //
          //       });
          //     },
          //   ),
          // ],
        ),
        body: Container(
          child: FutureBuilder(
            future: initPoem(),
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
                  var poemsList = snapshot.data.get('file');
                  var file = File(poemsList[i]);
                  var content = jsonDecode(file.readAsStringSync());
                  if(content[0]['trash']=="false"){
                    return SizedBox.shrink();
                  }
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction){
                      file.delete();
                      setState(() {
                        poemsList.removeAt(i);
                      });
                      initPoem();
                      snapshot.data.put('file', poemsList);
                      Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("DELETED.")));
                    },
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          content[0]['trash'] = "false";
                        });
                        file.writeAsString(jsonEncode(content), mode: FileMode.write);
                        Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("RESTORED.")));
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
                    background: Container(
                      margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), topRight: Radius.circular(15)),
                        color: Colors.red,
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(20),
                      child: Icon(Icons.delete, color: Colors.white,),
                    ),
                    direction: DismissDirection.endToStart,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}