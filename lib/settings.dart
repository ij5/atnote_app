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

  Future setAuthPrefs(bool auth)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('auth')==null){
      prefs.setBool('auth', auth);
    }
    prefs.setBool('auth', auth);
    return getAuthPrefs();
  }
  Future getAuthPrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('auth')==null){
      prefs.setBool('auth', false);
    }
    setState(() {
      authPref = prefs.getBool('auth');
    });
    return authPref;
  }

  Future<SharedPreferences> removePrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
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
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "App Lock ",
                  ),
                  Switch(
                    value: authPref,
                    activeColor: Colors.black,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey,
                    onChanged: (value){
                      getAuthPrefs();
                      if(authPref){
                        setAuthPrefs(false);
                      }else{
                        setAuthPrefs(true);
                      }
                    },
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                height: 20,
              ),
              FlatButton(
                child: Text("RESET"),
                onPressed: (){
                  poem.delete('file');
                  removePrefs();
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
    );
  }
}