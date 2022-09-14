import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/data/bible_books_model.dart';
import 'package:kjv_strong/logics/db_state.dart';
import 'package:kjv_strong/logics/providers.dart';
import 'package:kjv_strong/presentation/screens/highlights_screen.dart';
import 'package:kjv_strong/presentation/screens/search_screen.dart';
import 'package:kjv_strong/presentation/screens/verse_selection_screen.dart';
import 'package:kjv_strong/presentation/widgets/settings_widget.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  final DBState dbState;
  const CustomAppBar({Key? key, required this.dbState}) : super(key: key);

  @override
  ConsumerState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {

  late Future<List<Map<String, Object?>>> _list;

  @override
  void initState() {
    _list = widget.dbState.bibleDb.rawQuery('''select * from books''');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: FutureBuilder(
        future: _list,
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.done&&snapshot.data!=null){
            final list = snapshot.data!.map((e) => BibleNamesModel.fromJson(e)).toList();
            final currentBook = list.firstWhere((element) => element.bookNumber==ref.watch(bookIndexProvider),orElse: ()=>BibleNamesModel());
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>VerseSelectionScreen(dbState: widget.dbState)));
              },
              child: Row(
                children: [
                  Text('${currentBook.longName!} ${ref.watch(chapterNumberProvider)}'),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_drop_down_outlined)
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      actions: [

        IconButton(onPressed: (){
          showSearch(context: context, delegate: SearchDictionaryDefinitions());
        }, icon: const Icon(CupertinoIcons.search)),
        IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>const BookmarkScreen()));
        }, icon: const Icon(CupertinoIcons.bookmark)),
        IconButton(onPressed: (){
          SettingWidget.showSettingsDialog(context: context);
        }, icon: const Icon(Icons.settings)),
      ],
    );
  }
}
