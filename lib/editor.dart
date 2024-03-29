import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:path/path.dart';
import 'package:hive/hive.dart';
import 'dart:math';

void makeAlert(context, title, content, button) {
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
              Navigator.pop(context);
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

class ToolbarDelegate implements ZefyrToolbarDelegate{
  static const kDefaultButtonIcons = {
    ZefyrToolbarAction.bold: Icons.format_bold,
    ZefyrToolbarAction.italic: Icons.format_italic,
    ZefyrToolbarAction.link: Icons.link,
    ZefyrToolbarAction.unlink: Icons.link_off,
    ZefyrToolbarAction.clipboardCopy: Icons.content_copy,
    ZefyrToolbarAction.openInBrowser: Icons.open_in_new,
    ZefyrToolbarAction.heading: Icons.format_size,
    ZefyrToolbarAction.bulletList: Icons.format_list_bulleted,
    ZefyrToolbarAction.numberList: Icons.format_list_numbered,
    ZefyrToolbarAction.code: Icons.code,
    ZefyrToolbarAction.quote: Icons.format_quote,
    ZefyrToolbarAction.horizontalRule: Icons.remove,
    ZefyrToolbarAction.image: Icons.photo,
    ZefyrToolbarAction.cameraImage: Icons.photo_camera,
    ZefyrToolbarAction.galleryImage: Icons.photo_library,
    ZefyrToolbarAction.hideKeyboard: Icons.keyboard_hide,
    ZefyrToolbarAction.close: Icons.close,
    ZefyrToolbarAction.confirm: Icons.check,
  };

  static const kSpecialIconSizes = {
    ZefyrToolbarAction.unlink: 20.0,
    ZefyrToolbarAction.clipboardCopy: 20.0,
    ZefyrToolbarAction.openInBrowser: 20.0,
    ZefyrToolbarAction.close: 20.0,
    ZefyrToolbarAction.confirm: 20.0,
  };

  static const kDefaultButtonTexts = {
    ZefyrToolbarAction.headingLevel1: 'H1',
    ZefyrToolbarAction.headingLevel2: 'H2',
    ZefyrToolbarAction.headingLevel3: 'H3',
  };

  @override
  Widget buildButton(BuildContext context, ZefyrToolbarAction action,
      {VoidCallback onPressed}) {
    final theme = Theme.of(context);
    if(action==ZefyrToolbarAction.horizontalRule){
      return SizedBox.shrink();
    }
    if (kDefaultButtonIcons.containsKey(action)) {
      final icon = kDefaultButtonIcons[action];
      final size = kSpecialIconSizes[action];
      return ZefyrButton.icon(
        action: action,
        icon: icon,
        iconSize: size,
        onPressed: onPressed,
      );
    } else {
      final text = kDefaultButtonTexts[action];
      assert(text != null);
      final style = theme.textTheme.caption
          .copyWith(fontWeight: FontWeight.bold, fontSize: 14.0);
      return ZefyrButton.text(
        action: action,
        text: text,
        style: style,
        onPressed: onPressed,
      );
    }
  }
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
    setState(() {
      _controller = ZefyrController(Get.arguments==null?NotusDocument():Get.arguments[0]);
    });
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Get.back(result: []);
        return Future(()=>false);
      },
      child: Scaffold(
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Get.back(result: []);
            }
          ),
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
                  toolbarDelegate: ToolbarDelegate(),
                ),
              ),
      ),
    );
  }

  Future<void> _saveDocument(BuildContext context) async {
    final contents = jsonEncode(_controller.document);

    if(Get.arguments==null){
      final c = jsonDecode(contents);
      c.insert(0, {'title': c[0]['insert'].split('\n')[0], 'trash': 'false', 'heart': 'false'});

      Directory directory = await getApplicationDocumentsDirectory();
      final poemsDir = join(directory.path, 'poems');
      if(!Directory(poemsDir).existsSync()){
        Directory(poemsDir).createSync();
      }
      final path = join(poemsDir, getRandomString(10)+".json");
      File file;

      file = File(path);
      file.writeAsStringSync(jsonEncode(c));

      var poems = await Hive.openBox('poems');
      if(poems.get('file')==null){
        poems.put('file', []);
      }
      final input = poems.get('file');
      print(input);
      input.insert(0, path);
      poems.put('file', input);
      Get.back(result: [jsonEncode(c), file, jsonEncode(c), _controller.document]);
    }else{
      final c = jsonDecode(contents);
      c.insert(0, {
        'title': c[0]['insert'].split('\n')[0],
        'trash': jsonDecode(Get.arguments[2])[0]['trash'],
        'heart': jsonDecode(Get.arguments[2])[0]['heart']
      });

      Directory directory = await getApplicationDocumentsDirectory();
      final poemsDir = join(directory.path, 'poems');
      if(!Directory(poemsDir).existsSync()){
        Directory(poemsDir).createSync();
      }
      final path = join(poemsDir, getRandomString(10)+".json");
      File file;

      file = Get.arguments[1];
      file.writeAsString(jsonEncode(c)).then((value) {
        Get.back(result: [Get.arguments[2], file, jsonEncode(c), _controller.document]);
      });
    }
  }
}
