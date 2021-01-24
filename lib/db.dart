import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:atnote/poem.dart';

Database database;
initDB() async{
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'databases', 'poems.db');
  print(path);
  database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version)async{
        await db.execute("CREATE TABLE IF NOT EXISTS poems(id TEXT, title TEXT, [date] DATETIME, content TEXT, heart TEXT)");
      }
  );
}

deleteDB() async{
  final db = await database;
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'databases', 'poems.db');
  deleteDatabase(path);
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

getPoems() async{
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('poems');
  var result = List.generate(maps.length, (i) {
    return Poem(
      id: maps[i]['id'],
      title: maps[i]['title'],
      date: maps[i]['date'],
      content: maps[i]['content'],
      heart: maps[i]['heart'],
    );
  });
  return result;
}