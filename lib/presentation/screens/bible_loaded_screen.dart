import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/logics/bible_state_controller.dart';
import 'package:kjv_strong/logics/db_state.dart';
import 'package:kjv_strong/logics/providers.dart';
import 'package:kjv_strong/presentation/screens/verse_viewer_screen.dart';

class BibleLoadedScreen extends ConsumerStatefulWidget {
  final DBState dbState;
  const BibleLoadedScreen({Key? key, required this.dbState}) : super(key: key);

  @override
  ConsumerState createState() => _BibleLoadedScreenState();
}

class _BibleLoadedScreenState extends ConsumerState<BibleLoadedScreen> {

  @override
  void initState() {
    ref.read(bibleStateProvider.notifier).getVerses(bookId: ref.read(bookIndexProvider));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bible = ref.watch(bibleStateProvider);
    if(bible is BibleLoadedList){
      final totalChapters = bible.verses.map((e) => e.chapter).toSet().toList();
      return PageView.builder(
          controller: ref.watch(pageController),
          itemCount: totalChapters.length,
          onPageChanged: (int pageNumber){
            ref.read(boxStorageProvider).saveChapterIndex(pageNumber+1);
          },
          itemBuilder: (context,index){
            return VerseViewerScreen(
                verses: bible.verses.where((element) => element.chapter==index+1).toList(),
                commentaries:bible.commentaries.where((element) => element.chapterNumberFrom==index+1).toList(),
            );
          });
    }
    return const SizedBox.shrink();
  }
}
