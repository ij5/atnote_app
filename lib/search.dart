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
                    child: Text("Hello"),
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