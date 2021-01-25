import 'package:atnote/home.dart';
import 'package:atnote/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class Settings extends StatelessWidget{
  var poem;

  initPoem()async{
    poem = await Hive.openBox('poems');
    return poem;
  }

  @override
  Widget build(BuildContext context) {
    initPoem();
    return WillPopScope(
      onWillPop: (){
        Get.off(Home());
        return Future(()=>false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (){
              Get.off(Home());
            },
          ),
        ),
        body: Container(
          child: Column(
            children: [
              FlatButton(
                child: Text("RESET"),
                onPressed: (){
                  poem.delete('file');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}