import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
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
    );
  }

}