import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kjv_strong/data/bible_verses_model.dart';
import 'package:kjv_strong/data/constants.dart';

class BookmarksState extends StateNotifier<List<BibleVersesModel>>{
  BookmarksState() : super([]);

  final _box = GetStorage();


  Future<void> getBookmarks ()async{
    final List data = await _box.read(Constants.bookmarks);
    final bookmarks = data.map((e) => BibleVersesModel.fromJson(e)).toList();
    state = bookmarks;
  }

  Future<void> addBookmark({required BibleVersesModel verse})async{
    state = [...state,verse];
    await saveBookmark(verses: state);
  }

  saveBookmark({required List<BibleVersesModel> verses}){
    final  mappedData = verses.map((e) => e.toJson()).toList();
    _box.write(Constants.bookmarks, mappedData);
  }

  Future<void> removeBookmark({required BibleVersesModel verse})async{
    state = [...state]..removeWhere((element) => element==verse);
    await saveBookmark(verses: state);
  }
}