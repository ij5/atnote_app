import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class _Image implements ZefyrImageDelegate<ImageSource>{
  final picker = ImagePicker();

  @override
  Future<String> pickImage(ImageSource source) async{
    final file = await picker.getImage(source: source);
    if(file == null) return null;
    return file.path;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    final file = File.fromUri(Uri.parse(key));
    final image = FileImage(file);
    return Image(image: image,);
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  // TODO: implement gallerySource
  ImageSource get gallerySource => ImageSource.gallery;
}

class Editor extends StatefulWidget{
  @override
  _EditorState createState() => _EditorState();
}


class _EditorState extends State<Editor> {
  final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'poems.db'),
  );

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
              _saveDocument(context);
            },
          ),
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(15),
          controller: _controller,
          focusNode: _focusNode,
          imageDelegate: _Image(),
        ),
      ),
    );
  }

  NotusDocument _loadDocument(){
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context){
    final contents = jsonEncode(_controller.document);
    print(contents);
  }
}