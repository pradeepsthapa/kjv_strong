import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/data/bible_books_model.dart';
import 'package:kjv_strong/data/bible_verses_model.dart';
import 'package:kjv_strong/data/commentary_model.dart';
import 'package:kjv_strong/data/dictionary_number_model.dart';
import 'package:kjv_strong/data/dictionary_words_model.dart';
import 'db_state.dart';

abstract class BibleState{
  const BibleState();
}

class BibleInitial extends BibleState{
  const BibleInitial();
}

class BibleLoadedList extends BibleState{
  final List<BibleVersesModel> verses;
  final List<CommentaryModel> commentaries;
  const BibleLoadedList({required this.verses, required this.commentaries});
}

class BibleStateController extends StateNotifier<BibleState>{
  final DBState dbState ;
  BibleStateController(this.dbState) : super(const BibleInitial());

  Future<void> getVerses({required int bookId})async{
    state = const BibleInitial();
    final v = await dbState.bibleDb.rawQuery('''select * from verses where book_number==$bookId''');
    final c = await dbState.commentaryDb.rawQuery('''select * from commentaries where book_number==$bookId''');
    state = BibleLoadedList(
      verses: v.map((e) => BibleVersesModel.fromJson(e)).toList(),
      commentaries: c.map((e) => CommentaryModel.fromJson(e)).toList(),);
  }

  Future<List<BibleNamesModel>> getBibleNames() async{
    final b = await dbState.bibleDb.rawQuery('''select * from books''');
    return b.map((e) => BibleNamesModel.fromJson(e)).toList();
  }

  Future<List<DictionaryWordModel>> getDictionaryWords() async{
    final b = await dbState.dictionaryDb.rawQuery('''select * from dictionary''');
    return b.map((e) => DictionaryWordModel.fromJson(e)).toList();
  }

  Future<List<DictionaryNumberModel>> getDictionaryNumbers() async{
    final b = await dbState.dictionaryDb.rawQuery('''select * from cognate_strong_numbers''');
    return b.map((e) => DictionaryNumberModel.fromJson(e)).toList();
  }


}