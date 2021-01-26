import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:atnote/view.dart';

class Search extends StatelessWidget{
  var poems;

  initPoem()async{
    return await Hive.openBox('poems');
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("search"),
    );
  }

}