import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class Editor extends StatefulWidget{
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState(){
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.black,),
            onPressed: (){

            },
          ),
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(15),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }

  NotusDocument _loadDocument(){
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }
}