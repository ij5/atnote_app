import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:screen/screen.dart';
import 'home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:atnote/translate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox('poems');
  runApp(App());
  // Screen.keepOn(true);
}

void _initNotificationSettings()async{
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initSettingsAndroid = AndroidInitializationSettings('logo');
  final initSettings = InitializationSettings(android: initSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      title: "@note",
      home: Home(),
      locale: Get.deviceLocale,
    );
  }
}

