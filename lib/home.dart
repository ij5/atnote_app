import 'package:atnote/db.dart';
import 'package:atnote/editor.dart';
import 'package:atnote/favorite.dart';
import 'package:atnote/search.dart';
import 'package:atnote/index.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int currentIndex;
  List _page = <Widget>[
    Index(),
    Search(),
    Favorite()
  ];
  Widget _currentPage;

  @override
  void initState(){
    super.initState();
    currentIndex = 0;
    _currentPage = Index();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "@note",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Center(
          child: _currentPage
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "NEW",
        backgroundColor: Colors.black,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Editor()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: .2,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
            _currentPage = _page[index];
          });
        },
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.sticky_note_2_outlined, color: Colors.black,),
            activeIcon: Icon(Icons.sticky_note_2, color: Colors.blue,),
            title: Text("HOME"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.purple,
            icon: Icon(Icons.search, color: Colors.black,),
            activeIcon: Icon(Icons.search_outlined, color: Colors.purple),
            title: Text("SEARCH"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.red,
            icon: Icon(Icons.favorite_outline, color: Colors.black,),
            activeIcon: Icon(Icons.favorite, color: Colors.red),
            title: Text("FAVORITE"),
          ),
        ],
      ),
    );
  }
}