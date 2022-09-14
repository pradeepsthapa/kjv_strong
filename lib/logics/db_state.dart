import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBState{
  final Database bibleDb;
  final Database dictionaryDb;
  final Database commentaryDb;
  const DBState({required this.bibleDb, required this.dictionaryDb, required this.commentaryDb});


  static Future<DBState> initializeDatabase() async {

    final databasesPath = await getDatabasesPath();
    final biblePath = join(databasesPath, "kjv1611_strong.sqlite3");
    final dictionaryPath = join(databasesPath, "strong_dictionary.sqlite3");
    final commentaryPath = join(databasesPath, "commentaries.sqlite3");

    final bibleExist = await databaseExists(biblePath);
    final dictionaryExist = await databaseExists(dictionaryPath);
    final commentaryExist = await databaseExists(commentaryPath);
    if (!bibleExist) {
      await Directory(dirname(biblePath)).create(recursive: true);
      ByteData data = await rootBundle.load("assets/sqlite/kjv1611_strong.SQLite3");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(biblePath).writeAsBytes(bytes, flush: true);
    }
    if(!dictionaryExist){
      await Directory(dirname(dictionaryPath)).create(recursive: true);
      ByteData data = await rootBundle.load("assets/sqlite/strong_dictionary.SQLite3");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dictionaryPath).writeAsBytes(bytes, flush: true);
    }
    if(!commentaryExist){
      await Directory(dirname(commentaryPath)).create(recursive: true);
      ByteData data = await rootBundle.load("assets/sqlite/commentaries.SQLite3");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(commentaryPath).writeAsBytes(bytes, flush: true);
    }
    final bibleTable = await openDatabase(biblePath, readOnly: true);
    final dictionaryTable = await openDatabase(dictionaryPath, readOnly: true);
    final commentaryTable = await openDatabase(commentaryPath, readOnly: true);
    return DBState(bibleDb: bibleTable, dictionaryDb: dictionaryTable, commentaryDb: commentaryTable);
  }
}