import 'package:flutter/material.dart';
import 'package:atnote/db.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';


class Index extends StatefulWidget {
  @override
  IndexState createState() => IndexState();
}

class IndexState extends State<Index> {
  var poem;
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ValueListenableBuilder(
        valueListenable: Hive.box('poems').listenable(),
        builder: (context, box, widget){
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
              child: Text(""),
            ),
          );
        },
      ),
    );
  }
}
