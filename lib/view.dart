import 'dart:convert';
import 'package:atnote/editor.dart';
import 'package:atnote/home.dart';
import 'package:atnote/search.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:atnote/poem.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';


class CustomImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;

  @override
  Future<String> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.getImage(source: source);
    if (file == null) return null;
    return file.path;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    // We use custom "asset" scheme to distinguish asset images from other files.
    if (key.startsWith('asset://')) {
      final asset = AssetImage(key.replaceFirst('asset://', ''));
      return Image(image: asset);
    } else {
      // Otherwise assume this is a file stored locally on user's device.
      final file = File.fromUri(Uri.parse(key));
      final image = FileImage(file);
      return Image(image: image);
    }
  }
}

Delta getDelta(data) {
  var edited = json.decode(data) as List;
  edited.removeAt(0);
  return Delta.fromJson(edited);
}

class View extends StatefulWidget{
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final document = NotusDocument.fromDelta(getDelta(Get.arguments[0]));
    final file = Get.arguments[1];
    return WillPopScope(
      onWillPop: (){
        if(Get.arguments[2]==null){
          Get.off(Home());
        }else if(Get.arguments[2]=="search"){
          Get.back();
        }
        return Future(()=>false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(jsonDecode(Get.arguments[0])[0]['title']),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              if(Get.arguments[2]==null){
                Get.off(Home());
              }else if(Get.arguments[2]=="search"){
                Get.off(Home(), arguments:['search']);
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                Get.to(Editor(), arguments: [document,  file, Get.arguments[0], Get.arguments[2]]);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: ZefyrView(
              document: document,
              imageDelegate: CustomImageDelegate(),
            ),
          ),
        ),
      ),
    );
  }
}