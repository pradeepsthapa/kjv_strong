import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/data/bible_books_model.dart';
import 'package:kjv_strong/data/bible_verses_model.dart';
import 'package:kjv_strong/data/dictionary_words_model.dart';
import 'package:kjv_strong/logics/storage_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'bible_state_controller.dart';
import 'db_state.dart';
import 'highlight_state_controller.dart';
import 'interstitial_adervice.dart';

final fontSizeProvider = StateProvider<double>((ref)=>18.0);
final appColorProvider = StateProvider<int>((ref)=>9);
final globalFontProvider = StateProvider<int>((ref)=>0);
final alwaysShowCommentaryProvider = StateProvider<bool>((ref)=>true);
final showStrongNumberProvider = StateProvider<bool>((ref)=> true);
final bookIndexProvider = StateProvider<int>((ref)=> 10);
final chapterNumberProvider = StateProvider<int>((ref)=> 1);
final currentVerseProvider = StateProvider<int>((ref)=> 0);

final dbProvider = FutureProvider<DBState>((ref)=>DBState.initializeDatabase());

final bibleNamesProvider = FutureProvider<List<BibleNamesModel>>((ref)=>BibleStateController(ref.read(dbProvider).value!).getBibleNames());
final dictionaryWordsProvider = FutureProvider<List<DictionaryWordModel>>((ref)=>BibleStateController(ref.read(dbProvider).value!).getDictionaryWords());

final bibleStateProvider = StateNotifierProvider<BibleStateController,BibleState>((ref) => BibleStateController(ref.read(dbProvider).value!),);
final boxStorageProvider = ChangeNotifierProvider<StorageProvider>((ref)=>StorageProvider(ref.read)..initStorage());
final scrollController = StateProvider<ItemScrollController>((ref)=>ItemScrollController());
final pageController = Provider<PageController>((ref)=>PageController(initialPage: ref.read(chapterNumberProvider)-1));

final bookmarksStateProvider = StateNotifierProvider<BookmarksState,List<BibleVersesModel>>((ref)=>BookmarksState()..getBookmarks());


final interstitialAdProvider = Provider<InterstitialAdService>((ref)=>InterstitialAdService());