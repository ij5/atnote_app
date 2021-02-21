import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:convert';
import 'package:atnote/view.dart';

class Search extends StatefulWidget{
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var poems;
  List<String> queryData;
  String _query = "";


  initPoem()async{
    poems = await Hive.openBox('poems');
    return poems;
  }

  @override
  void initState(){
    super.initState();

  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initPoem();
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: FloatingSearchBar(
        hint: "Search...",
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: NeverScrollableScrollPhysics(),
        axisAlignment: isPortrait?0.0:-1.0,
        openAxisAlignment: 0.0,
        maxWidth: isPortrait?600:500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query){
          setState(() {
            this._query = query;
          });
        },
        transition: SlideFadeFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition){
          return FutureBuilder(
            future: initPoem(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                itemCount: snapshot.data.get('file')==null?0:snapshot.data.get('file').length,
                itemBuilder: (BuildContext context, int i){
                  var file = File(snapshot.data.get('file')[i]);
                  var rawContent = file.readAsStringSync();
                  var content = jsonDecode(rawContent);
                  if(content[0]['trash']=="true"){
                    return SizedBox.shrink();
                  }
                  if(!rawContent.toLowerCase().contains(_query.toLowerCase())){
                    return SizedBox.shrink();
                  }
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction){
                      content[0]['trash'] = "true";
                      file.writeAsString(jsonEncode(content));
                      Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("Moved to trash.")));
                    },
                    child: GestureDetector(
                      onTap: (){
                        Get.to(View(), arguments: [jsonEncode(content), file, null]).then((value){
                          setState(() {
                            content = value[0];
                          });
                        });
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
                                file.writeAsStringSync(jsonEncode(content));
                              },
                            )
                                :InkWell(
                              child: Icon(Icons.favorite_outline),
                              onTap: (){
                                setState(() {
                                  content[0]['heart'] = "true";
                                });
                                file.writeAsStringSync(jsonEncode(content));
                              },
                            ),
                            right: 30,
                            bottom: 25,
                          ),
                        ],
                      ),
                    ),
                    background: Container(
                      margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), topRight: Radius.circular(15)),
                        color: Colors.red,
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(20),
                      child: Icon(Icons.delete, color: Colors.white,),
                    ),
                    direction: DismissDirection.endToStart,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}