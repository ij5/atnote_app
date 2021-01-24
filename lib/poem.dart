import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


class Poem{
  final String id;
  final String title;
  final String date;
  final String content;
  final String file;
  final String heart;

  Poem({this.id, this.title, this.date, this.content, this.file, this.heart});

  Map<String, dynamic> toMap(){
    return {
      'id': getRandomString(30),
      'title': this.title,
      'date': this.date,
      'content': this.content,
      'file': this.file,
      'heart': this.heart,
    };
  }
}