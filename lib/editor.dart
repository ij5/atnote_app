import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:path/path.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

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

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


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

    Directory directory = await getApplicationDocumentsDirectory();
    final poemsDir = join(directory.path, 'poems');
    if(!Directory(poemsDir).existsSync()){
      Directory(poemsDir).createSync();
    }
    final path = join(poemsDir, getRandomString(10)+".json");
    final file = File(path);
    file.writeAsString(jsonEncode(c)).then((value) {
      makeAlert(context, "", "Saved.", "OK", true);
    });

    var poems = await Hive.openBox('poems');
    if(poems.get('file')==null){
      poems.put('file', []);
    }
    final input = poems.get('file');
    input.insert(0, path);
    poems.put('file', input);
  }
}
