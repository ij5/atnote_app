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

  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState(){
    super.initState();
    _loadDocument().then((document){
      setState(() {
        _controller = ZefyrController(document);
      });
    });
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
      body: _controller==null?Center(child: CircularProgressIndicator(),):ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(15),
          controller: _controller,
          focusNode: _focusNode,
          imageDelegate: _Image(),
        ),
      ),
    );
  }

  Future<NotusDocument> _loadDocument() async{
    final file = File(join(, 'file.json'));
    print(join(, 'file.json'));
    if(await file.exists()){
      final contents = await file.readAsString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context){
    final contents = jsonEncode(_controller.document);
    final file = File(join(Directory.systemTemp.path, 'file.json'));
    file.writeAsString(contents).then((value){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
    });
  }
}