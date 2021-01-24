import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:atnote/index.dart';
import 'package:atnote/poem.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:atnote/db.dart';

void makeAlert(context, title, content, button, close) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          new FlatButton(
            child: Text(button),
            onPressed: () {
              if (close) {
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}


class _Image implements ZefyrImageDelegate<ImageSource> {
  final picker = ImagePicker();

  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await picker.getImage(source: source);
    if (file == null) return null;
    return file.path;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    final file = File.fromUri(Uri.parse(key));
    final image = FileImage(file);
    return Image(
      image: image,
    );
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  // TODO: implement gallerySource
  ImageSource get gallerySource => ImageSource.gallery;
}

class Editor extends StatefulWidget {
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {


  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _loadDocument().then((document) {
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
        title: Text(
          "Edit",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actionsIconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.black,
            ),
            onPressed: () {
              _saveDocument(context);
            },
          ),
        ],
      ),
      body: _controller == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ZefyrScaffold(
              child: ZefyrEditor(
                padding: EdgeInsets.all(15),
                controller: _controller,
                focusNode: _focusNode,
                imageDelegate: _Image(),
              ),
            ),
    );
  }

  Future<NotusDocument> _loadDocument() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(join(directory.path, 'poems','file.json'));
    if (await file.exists()) {
      final c = await file.readAsString();
      final contents = jsonDecode(c);
      contents.removeAt(0);
      return NotusDocument.fromJson(contents);
    }
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  Future<void> _saveDocument(BuildContext context) async {
    final contents = jsonEncode(_controller.document);
    final c = jsonDecode(contents);
    c.insert(0, {'title': c[0]['insert'].split('\n')[0]});
    print(DateTime.now());
    var p = Poem(
      title: c[1]['insert'].split('\n')[0],
      date: DateTime.now().toString(),
      content: contents,
      heart: "false"
    );
    insertDB(p);
    makeAlert(context, "", "Saved.", "OK", true);
    // final directory = await getApplicationDocumentsDirectory();
    // final file = File(join(directory.path, 'poems', 'file.json'));
    // file.writeAsString(jsonEncode(c)).then((value) {
    //   makeAlert(context, "", "Saved.", "OK", true);
    // });
  }
}
