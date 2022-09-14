import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/data/bible_books_model.dart';
import 'package:kjv_strong/data/bible_verses_model.dart';
import 'package:kjv_strong/logics/providers.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:selectable/selectable.dart';

class VerseViewerDialog{

  static void showVerseDialog(String  refLink, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final b = refLink.split(" ");
    final int bookId = int.parse(b.first.split(":").last);
    final int chapter = int.parse(b.last.split(":").first);
    final String v = b.last.split(":").last;
    int verseIndex = 1;
    if(!v.contains("-")){
      verseIndex = int.parse(b.last.split(":").last);
    }
    else{
      verseIndex = int.parse(v.split("-").first);
    }

    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 150),
            barrierColor: Colors.black38,
            barrierDismissible: true),
        context: context,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.center,
            child: Card(
              color: isDark ? Colors.grey[900] : null,
              elevation: 7,
              shadowColor: Colors.black87,
              margin: EdgeInsets.zero,
              child: SingleChildScrollView(
                child: Consumer(builder: ( context, WidgetRef ref, child) {
                  final b = ref.watch(dbProvider).value;
                  final currentBook = ref.watch(bibleNamesProvider);
                  return FutureBuilder(
                    future: b!.bibleDb.rawQuery('''select * from verses where book_number == $bookId and chapter == $chapter'''),
                    builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
                      if(snapshot.connectionState == ConnectionState.done&&snapshot.data!=null){
                        final verses = snapshot.data!.map((e) => BibleVersesModel.fromJson(e)).toList();
                        return SizedBox(
                          height: MediaQuery.of(context).size.height *.8,
                          width: MediaQuery.of(context).size.width *.9,
                          child: Scaffold(
                              appBar: PreferredSize(
                                preferredSize: const Size.fromHeight(50),
                                child: AppBar(
                                  title: Text('${currentBook.value!.firstWhere((element) => element.bookNumber==bookId,orElse: ()=>BibleNamesModel()).longName!} $chapter:$v'),
                                ),
                              ),
                              body: _ReferenceVerseDisplayScreen(verseIndex: verseIndex-1, verses: verses)),
                        );
                      }
                      return const Center(child: CircularProgressIndicator(),);
                    },
                  );
                },),
              ),
            ),
          );
        });
  }
}

class _ReferenceVerseDisplayScreen extends ConsumerStatefulWidget {
  final List<BibleVersesModel> verses;
  final int verseIndex;
  const _ReferenceVerseDisplayScreen({Key? key, required this.verses, required this.verseIndex}) : super(key: key);

  @override
  ConsumerState createState() => _ReferenceVerseDisplayScreenState();
}

class _ReferenceVerseDisplayScreenState extends ConsumerState<_ReferenceVerseDisplayScreen> {


  late final ItemScrollController itemScrollController;
  late final ItemPositionsListener itemPositionsListener;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(mounted) itemScrollController.scrollTo(index:widget.verseIndex, duration: const Duration(milliseconds: 300),curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selectable(
      child: ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemCount: widget.verses.length,
          itemBuilder: (context,index){
            final verse = widget.verses[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(verse.verse.toString(),style: TextStyle(color: Theme.of(context).textTheme.caption?.color,fontSize: 12),),
                Expanded(
                  child: Html(
                    data:verse.text??'',
                    tagsList: Html.tags..addAll(['pb','t','j','s']),
                    style:{
                      '*':Style(
                        fontSize: FontSize(ref.watch(fontSizeProvider)),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                      ),
                      'j':Style(
                          color: Colors.red
                      ),
                    },
                    customRender: {
                      'pb':(context,child){
                        return child;
                      },
                      't':(context,child){
                        return child;
                      },
                      'j':(context,child){
                        return child;
                      },
                      's':(context,child){
                        return const SizedBox.shrink();
                      },
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}