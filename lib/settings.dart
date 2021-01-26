import 'package:atnote/home.dart';
import 'package:atnote/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget{
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var poem;

  initPoem()async{
    poem = await Hive.openBox('poems');
    return poem;
  }

  var authPref = false;

  Future setAuthPrefs(auth)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('auth')==null){
      prefs.setBool('auth', auth);
    }
    prefs.setInt('auth', auth);
  }
  Future getAuthPrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      authPref = prefs.getBool('auth');
    });
    return authPref;
  }

  @override
  void initState(){
    super.initState();
    getAuthPrefs();
  }

  @override
  Widget build(BuildContext context) {
    initPoem();

    return WillPopScope(
      onWillPop: (){
        Get.off(Home());
        return Future(()=>false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (){
              Get.off(Home());
            },
          ),
        ),
        body: Container(
          child: SizedBox.expand(
            child: Center(
              child: Column(
                children: [
                  Switch(
                    value: authPref,
                    activeColor: Colors.black,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey,
                    onChanged: (value){
                      getAuthPrefs();
                      if(authPref){
                        setAuthPrefs(0);
                      }else{
                        setAuthPrefs(1);
                      }
                    },
                  ),
                  FlatButton(
                    child: Text("RESET"),
                    onPressed: (){
                      poem.delete('file');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.red),
                    ),
                    color: Colors.white,
                    textColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}