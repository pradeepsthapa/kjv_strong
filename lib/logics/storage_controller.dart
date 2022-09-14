import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kjv_strong/data/constants.dart';
import 'package:kjv_strong/logics/providers.dart';

class StorageProvider extends ChangeNotifier{
  final Reader _reader;
  StorageProvider(this._reader);

  final _box = GetStorage();

  bool _isDark = false;
  bool get isDark => _isDark;

  void changeDarkTheme(bool value){
    _box.write(Constants.darkMode, value);
    _isDark = value;
    notifyListeners();

  }

  void saveFontSize(double size){
    _box.write(Constants.fontSize, size);
    _reader(fontSizeProvider.state).state = size;
  }

  void saveBackground(int color){
    _box.write(Constants.backgroundColor, color);
    _reader(appColorProvider.state).state = color;
  }

  void saveFontStyle(int index){
    _box.write(Constants.fontIndex, index);
    _reader(globalFontProvider.state).state = index;
  }

  void saveChapterIndex(int pageIndex){
    _box.write(Constants.chapterIndex, pageIndex);
    _reader(chapterNumberProvider.state).state = pageIndex;
  }

  void saveBookIndex(int index){
    _box.write(Constants.bibleIndex, index);
    _reader(bookIndexProvider.state).state = index;
  }

  void saveAlwaysShowCommentary(bool value){
    _box.write(Constants.showCommentary, value);
    _reader(alwaysShowCommentaryProvider.state).state = value;
  }


  void initStorage(){
    _box.writeIfNull(Constants.darkMode, false);
    _box.writeIfNull(Constants.fontSize, 18.0);
    _box.writeIfNull(Constants.backgroundColor, 9);
    _box.writeIfNull(Constants.fontIndex, 0);
    _box.writeIfNull(Constants.pageIndex, 0);
    _box.writeIfNull(Constants.bibleIndex, 10);
    _box.writeIfNull(Constants.chapterIndex, 1);
    _box.writeIfNull(Constants.showCommentary, true);
    _box.writeIfNull(Constants.bookmarks, <Map<String,dynamic>>[]);
    initialDarkMode();
  }

  void initialDarkMode(){
    _isDark = _box.read(Constants.darkMode);
    notifyListeners();
  }

  void loadInitials() {
    _reader(fontSizeProvider.state).state =  _box.read(Constants.fontSize);
    _reader(appColorProvider.state).state =  _box.read(Constants.backgroundColor);
    _reader(globalFontProvider.state).state =  _box.read(Constants.fontIndex);
    _reader(bookIndexProvider.state).state =  _box.read(Constants.bibleIndex);
    _reader(chapterNumberProvider.state).state =  _box.read(Constants.chapterIndex);
    _reader(alwaysShowCommentaryProvider.state).state =  _box.read(Constants.showCommentary);
  }
}