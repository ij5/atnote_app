import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:atnote/view.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Search extends StatefulWidget{
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var poems;

  initPoem()async{
    return await Hive.openBox('poems');
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          FloatingSearchBar(
            hint: "Search...",
            scrollPadding: EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 800),
            transitionCurve: Curves.easeInOut,
            physics: const BouncingScrollPhysics(),
            axisAlignment: isPortrait?0.0:-1.0,
            openAxisAlignment: 0.0,
            maxWidth: isPortrait?600:500,
            debounceDelay: const Duration(milliseconds: 500),
            onQueryChanged: (query){

            },
            transition: CircularFloatingSearchBarTransition(),
            actions: [
              FloatingSearchBarAction(
                showIfOpened: false,
                child: CircularButton(
                  icon: const Icon(null),
                  onPressed: () {},
                ),
              ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            builder: (context, transition) {
              return FutureBuilder(
                future: initPoem(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }
                  return Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      itemCount: snapshot.data.get('file')==null?0:snapshot.data.get('file').length,
                      itemBuilder: (BuildContext context, int i){
                        var file = File(snapshot.data.get('file')[i]);
                        var content = jsonDecode(file.readAsStringSync());
                        if(content[0]['trash']=="true"){
                          return SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: (){
                            Get.off(View(), arguments: [jsonEncode(content), file, "search"]);
                          },
                          child: Stack(
                            children: [
                              Container(
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
                                  child: Text(content[0]['title']),
                                ),
                              ),
                              Positioned(
                                child: content[0]['heart']=="true"
                                    ?InkWell(
                                  child: Icon(Icons.favorite, color: Colors.red,),
                                  onTap: (){
                                    setState(() {
                                      content[0]['heart'] = "false";
                                    });
                                    file.writeAsString(jsonEncode(content));
                                  },
                                )
                                    :InkWell(
                                  child: Icon(Icons.favorite_outline),
                                  onTap: (){
                                    setState(() {
                                      content[0]['heart'] = "true";
                                    });
                                    file.writeAsString(jsonEncode(content));
                                  },
                                ),
                                right: 30,
                                bottom: 25,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}