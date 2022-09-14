import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/data/bible_books_model.dart';
import 'package:kjv_strong/data/bible_verses_model.dart';
import 'package:kjv_strong/logics/db_state.dart';
import 'package:kjv_strong/logics/providers.dart';
import 'package:kjv_strong/presentation/widgets/facebook_native_banner.dart';

class VerseSelectionScreen extends ConsumerStatefulWidget {
  final DBState dbState;
  const VerseSelectionScreen({Key? key,required this.dbState}) : super(key: key);

  @override
  ConsumerState createState() => _VerseSelectionScreenState();
}

class _VerseSelectionScreenState extends ConsumerState<VerseSelectionScreen> with SingleTickerProviderStateMixin{

  late final TabController _tabController;
  late int _currentIndex = 0;

  Widget _tabText(String s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(s),
    );
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3,initialIndex: 0, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabController.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_currentIndex==0?"Select Book":(_currentIndex==1?"Select Chapter":"Select Verse")),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                _tabText("BOOKS"),
                _tabText("CHAPTERS"),
                _tabText("VERSES"),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              ref.watch(bibleNamesProvider).when(
                  data: (bookNames){
                    return ListView(
                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 9),
                      children: [
                        Text("OLD TESTAMENT",style: Theme.of(context).textTheme.headline6?.copyWith(color: Theme.of(context).colorScheme.secondary),),
                        _BookGridView(books: bookNames.getRange(0, 39).toList(),tabController: _tabController,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text("NEW TESTAMENT",style: Theme.of(context).textTheme.headline6?.copyWith(color: Theme.of(context).colorScheme.secondary),),
                        ),
                        _BookGridView(books: bookNames.getRange(39, 66).toList(),tabController: _tabController),
                      ],
                    );
                  },
                  error: (_,__)=>const SizedBox.shrink(),
                  loading: ()=> const Center(child: CircularProgressIndicator())),

              _ChapterView(tabController: _tabController, dbState: widget.dbState),
              _VerseView(dbState: widget.dbState),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ref.read(interstitialAdProvider).showMainAds();
              Navigator.pop(context);
            },
            child: const Icon(CupertinoIcons.check_mark),),
          bottomNavigationBar: const NativeBannerAdWidget(),

        ));
  }
}


class _BookGridView extends ConsumerWidget {
  final List<BibleNamesModel> books;
  final TabController tabController;
  const _BookGridView({Key? key, required this.books, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 50,
          crossAxisCount: 3),
      itemBuilder: (context,index){
        final book = books[index];
        final color = '0xFF${book.bookColor!.substring(1,book.bookColor!.length)}';
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: OutlinedButton(onPressed: (){
            ref.read(boxStorageProvider).saveBookIndex(book.bookNumber!);
            ref.read(boxStorageProvider).saveChapterIndex(1);
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ref.read(bibleStateProvider.notifier).getVerses(bookId: book.bookNumber!);
              ref.read(pageController).jumpToPage(0);
            });
            tabController.animateTo(1,duration: const Duration(milliseconds: 500));
          },
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isDark?Colors.white70:Theme.of(context).primaryColor,width: 0.7),
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                  backgroundColor: Theme.of(context).cardColor
              ),
              child: Text(book.longName??'',textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark?Colors.white:Color(int.parse(color)).withGreen(100),
                  // color: Theme.of(context).colorScheme.secondary,
                ),
              )),
        );
      },
    );
  }
}

class _ChapterView extends ConsumerStatefulWidget {
  final DBState dbState;
  final TabController tabController;
  const _ChapterView({Key? key, required this.tabController, required this.dbState}) : super(key: key);

  @override
  ConsumerState createState() => _ChapterViewState();
}

class _ChapterViewState extends ConsumerState<_ChapterView> {

  late Future<List<Map<String, Object?>>> _list;

  @override
  void initState() {
    _list = widget.dbState.bibleDb.rawQuery('''select * from verses where book_number==${ref.read(bookIndexProvider)}''');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder(
      future: _list,
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
        if(snapshot.connectionState == ConnectionState.done&&snapshot.data!=null){
          final list = snapshot.data?.map((e) => BibleVersesModel.fromJson(e)).toList()??[];
          final chapterNumbers = list.map((e) => e.chapter).toSet().toList();
          return GridView.builder(
              itemCount: chapterNumbers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 50,
                  crossAxisCount: 4),
              itemBuilder: (context,index){
                final chapter = chapterNumbers[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDark?Colors.white70:Theme.of(context).primaryColor,width: 0.7),
                        elevation: 3,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        backgroundColor: Theme.of(context).cardColor
                    ),
                    onPressed: () {
                      ref.read(boxStorageProvider).saveChapterIndex(chapter!);
                      ref.read(pageController).jumpToPage(chapter-1);
                      widget.tabController.animateTo(2);
                    },
                    child: Text(chapter.toString(),style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                  ),
                );
              });
        }
        return const SizedBox.shrink();
      },

    );
  }
}

class _VerseView extends ConsumerStatefulWidget {
  final DBState dbState;
  const _VerseView({Key? key, required this.dbState}) : super(key: key);

  @override
  ConsumerState createState() => _VerseViewState();
}

class _VerseViewState extends ConsumerState<_VerseView> {

  late Future<List<Map<String, Object?>>> _list;

  @override
  void initState() {
    _list = widget.dbState.bibleDb.rawQuery('''select * from verses where book_number==${ref.read(bookIndexProvider)} and chapter == ${ref.read(chapterNumberProvider)}''');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder(
      future: _list,
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
        if(snapshot.connectionState == ConnectionState.done&&snapshot.data!=null){
          final list = snapshot.data?.map((e) => BibleVersesModel.fromJson(e)).toList()??[];
          final verseNumbers = list.map((e) => e.verse).toSet().toList();
          return GridView.builder(
              itemCount: verseNumbers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 50,
                  crossAxisCount: 4),
              itemBuilder: (context,index){
                final verse = verseNumbers[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDark?Colors.white70:Theme.of(context).primaryColor,width: 0.7),
                        elevation: 3,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        backgroundColor: Theme.of(context).cardColor
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ref.read(scrollController).scrollTo(index:verse!-1, duration: const Duration(milliseconds: 400),curve: Curves.easeOut);
                      });
                      ref.read(interstitialAdProvider).showMainAds();
                    },
                    child: Text(verse.toString(),style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                  ),
                );
              });
        }
        return const SizedBox.shrink();
      },

    );
  }
}