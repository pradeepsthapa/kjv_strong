import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/data/bible_verses_model.dart';
import 'package:kjv_strong/data/commentary_model.dart';
import 'package:kjv_strong/logics/providers.dart';
import 'package:kjv_strong/presentation/widgets/referenec_verse_viewer_widget.dart';
import 'package:kjv_strong/presentation/widgets/strongs_word_viewer_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:selectable/selectable.dart';
import 'package:share/share.dart';

class VerseViewerScreen extends ConsumerStatefulWidget {
  final List<BibleVersesModel> verses;
  final List<CommentaryModel> commentaries;
  const VerseViewerScreen({Key? key, required this.verses, required this.commentaries}) : super(key: key);

  @override
  ConsumerState createState() => _VerseViewerScreenState();
}

class _VerseViewerScreenState extends ConsumerState<VerseViewerScreen> {

  late final ItemScrollController itemScrollController;
  late final ItemPositionsListener itemPositionsListener;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
    itemPositionsListener.itemPositions.addListener(() {
      ref.read(currentVerseProvider.state).state = itemPositionsListener.itemPositions.value.first.index;
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(mounted) ref.read(scrollController.state).state = itemScrollController;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlights = ref.watch(bookmarksStateProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Selectable(
        child: ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemCount: widget.verses.length,
          itemBuilder: (BuildContext context, int index) {
            final verse = widget.verses[index];
            final referenceVerses = widget.commentaries.where((element) => element.verseNumberFrom==verse.verse).toList();
            final highlightedVerse = highlights.firstWhere((element) => element.text==verse.text,orElse: ()=>BibleVersesModel());
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Wrap(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(verse.verse.toString(),style: TextStyle(color: Theme.of(context).textTheme.caption?.color,fontSize: 12),),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            _showHighlightDialog(context:context,verse:verse);
                          },
                          child: Html(
                            data:verse.text??'',
                            tagsList: Html.tags..addAll(['pb','t','j','s']),
                            style:{
                              '*':Style(
                                fontSize: FontSize(ref.watch(fontSizeProvider)),
                                display: Display.INLINE,
                                backgroundColor: highlightedVerse.colorIndex!=null?Colors.accents[highlightedVerse.colorIndex!].withOpacity(0.12):null,
                              ),
                              'j':Style(
                                  color: Colors.red,
                              ),
                              's':Style(
                                  color: Theme.of(context).colorScheme.secondary,
                                  textDecoration: TextDecoration.underline,
                                  margin: const EdgeInsets.only(left: 1)
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
                              's':(_,child){
                                return GestureDetector(onTap: () {
                                  final String strongNumber = _.tree.element?.innerHtml??'';
                                  StrongWordViewerDialog.showDictionaryWordDialog(
                                      word: strongNumber,
                                      context: context,
                                      isNT: verse.bookNumber!<470?false:true);
                                  },
                                    child: ref.watch(showStrongNumberProvider)?child:const SizedBox.shrink());
                              },
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if(referenceVerses.isNotEmpty&&ref.watch(alwaysShowCommentaryProvider)) Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: isDark?Colors.white10:Theme.of(context).primaryColor.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(3)
                      ),
                      child: Wrap(
                        children: referenceVerses.map((e) {
                          return Html(
                            data: e.text,
                            onLinkTap: (url, _, __, ___) {
                              VerseViewerDialog.showVerseDialog(url??'', context);
                            },
                            style:{
                              '*':Style(
                                fontSize: FontSize(ref.watch(fontSizeProvider)-2),
                                margin: const EdgeInsets.symmetric(vertical: 2),
                              ),
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },),
      ),
    );
  }

  void _showHighlightDialog({required BuildContext context, required BibleVersesModel verse}) {
    showModal(
        context: context,
        configuration: const FadeScaleTransitionConfiguration(
            barrierColor: Colors.transparent,
            barrierDismissible: true),
        builder: (BuildContext context) {
          return Consumer(
              builder: (context, ref,child) {
                final state = ref.watch(bibleNamesProvider);
                final currentBook = state.value?.firstWhere((element) => element.bookNumber==verse.bookNumber);
                final highlights = ref.watch(bookmarksStateProvider);
                final highlightedVerse = highlights.firstWhere((element) => element.text==verse.text,orElse: ()=>BibleVersesModel());
                String v = verse.text!.replaceAll(RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true), '').replaceAll(RegExp(r'\d'), "");
                return Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 9),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            selected: true,
                            dense: true,
                            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.7),
                            title: Text('${currentBook!.longName!} ${verse.chapter}:${verse.verse}',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                          ),
                          // ListTile(
                          //   onTap: () {
                          //     Clipboard.setData(ClipboardData(text: v+'-${currentBook.longName} ${verse.chapter}:${verse.verse}'));
                          //     Navigator.pop(context);
                          //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verse copied to clipboard"),));
                          //   },
                          //   dense: true,
                          //   leading: Icon(Icons.copy,color: Theme.of(context).colorScheme.secondary),
                          //   trailing: Icon(Icons.chevron_right,color: Theme.of(context).colorScheme.secondary),
                          //   title: Text("Copy Verse",style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),),
                          // ),
                          const Divider(height: 0),
                          ListTile(
                            onTap: () {
                              final RenderBox renderBox = context.findRenderObject() as RenderBox;
                              Navigator.pop(context);
                              Share.share('$v-${currentBook.longName} ${verse.chapter}:${verse.verse}',subject:"Share Verse",sharePositionOrigin: renderBox.localToGlobal(Offset.zero)&renderBox.size);
                            },
                            dense: true,
                            leading: Icon(Icons.share_rounded,color: Theme.of(context).colorScheme.secondary),
                            trailing: Icon(Icons.chevron_right,color: Theme.of(context).colorScheme.secondary),
                            title: Text("Share Verse",style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),),
                          ),
                          const Divider(height: 0),
                          ListTile(
                            dense: true,
                            leading: Icon(Icons.bookmark_border,color: Theme.of(context).colorScheme.secondary),
                            // trailing: Icon(Icons.chevron_right,color: Theme.of(context).colorScheme.secondary),
                            title: Text("Highlight Verse",style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),),
                          ),
                          const Divider(height: 0),
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: Colors.accents.length,
                                itemBuilder: (context,index){
                                  final color = Colors.accents[index];
                                  if (index==0){
                                    return GestureDetector(
                                      onTap: (){
                                        if(highlightedVerse.verse!=null){
                                          ref.read(bookmarksStateProvider.notifier).removeBookmark(verse: highlightedVerse);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Container(
                                        width: 35,
                                        margin: const EdgeInsets.symmetric(horizontal: 1,vertical: 1),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: highlightedVerse.verse==null?Border.all():null
                                        ),
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: (){
                                      if(highlightedVerse.verse!=null&&highlightedVerse.colorIndex==index){
                                        ref.read(bookmarksStateProvider.notifier).removeBookmark(verse: highlightedVerse);
                                        Navigator.pop(context);
                                        return;
                                      }
                                      if(highlightedVerse.verse!=null&&highlightedVerse.colorIndex!=index){
                                        ref.read(bookmarksStateProvider.notifier).removeBookmark(verse: highlightedVerse);
                                        ref.read(bookmarksStateProvider.notifier).addBookmark(verse: verse.copyWith(colorIndex: index));
                                        Navigator.pop(context);
                                        return;
                                      }
                                      else{
                                        ref.read(bookmarksStateProvider.notifier).addBookmark(verse: verse.copyWith(colorIndex: index));
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Container(
                                      width: 35,
                                      margin: const EdgeInsets.symmetric(horizontal: 1,vertical: 1),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: highlightedVerse.verse!=null&&highlightedVerse.colorIndex==index?Border.all():null,
                                        // color: color,
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: color
                                            ),),
                                          if(highlightedVerse.verse!=null&&highlightedVerse.colorIndex==index) const Center(child: Icon(Icons.close,color: Colors.white70))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ));
              }
          );
        });
  }
}
