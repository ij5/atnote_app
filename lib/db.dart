import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Poem{
  final int id;
  final String title;
  final String date;
  final String file;
  final String heart;

  Poem({this.id, this.title, this.date, this.file, this.heart});

  Map<String, dynamic> toMap(){
    return {
      'id': this.id,
      'title': this.title,
      'date': this.date,
      'file': this.file,
      'heart': this.heart,
    };
  }
}

Database database;
initDB() async{
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'databases', 'poems.db');
  database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version)async{
        await db.execute("CREATE TABLE IF NOT EXISTS poems(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, [date] DATETIME, file TEXT, heart TEXT)");
      }
  );
}

insertDB(Poem poem) async{
  final db = await database;
  print(poem.toMap());
  await db.insert('poems', poem.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}

updateDB(Poem poem) async{
  final db = await database;
  print(poem.toMap());
}