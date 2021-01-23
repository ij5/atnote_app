import 'package:flutter/material.dart';

class New extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: (){},
        ),
      ),
    );
  }

}