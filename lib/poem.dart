import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Poem extends HiveObject{
  @HiveField(0)
  String title;
  @HiveField(1)
  String date;
  @HiveField(2)
  String content;
  @HiveField(3)
  String heart;

  Poem({this.title, this.date, this.content, this.heart});

  Map<String, dynamic> toMap(){
    return {
      'title': this.title,
      'date': this.date,
      'content': this.content,
      'heart': this.heart,
    };
  }
}