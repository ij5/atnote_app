import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Search extends StatelessWidget{
  var poems;

  initPoem()async{
    return await Hive.openBox('poems');
  }



  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      child: FloatingSearchBar(
        hint: "Search...",
        scrollPadding: const EdgeInsets.only(top: 50, bottom: 70),
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
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition){
          return FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return
            },
          );
        },
      ),
    );
  }

}