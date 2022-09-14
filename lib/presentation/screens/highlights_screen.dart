import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/data/bible_books_model.dart';
import 'package:kjv_strong/logics/providers.dart';
import 'package:kjv_strong/presentation/widgets/facebook_native_banner.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final bookmarks = ref.watch(bookmarksStateProvider);
    final books = ref.watch(bibleNamesProvider);

    return WillPopScope(
      onWillPop: () async{
        ref.read(interstitialAdProvider).showMainAds();
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              title: const Text("Highlighted Verses"),
            )),
        body: bookmarks.isEmpty?Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("📚",style: TextStyle(fontSize: 40),),
            const SizedBox(height: 10),
            Text("You have no highlights yet",style: TextStyle(color: Colors.grey[500],fontSize: 24),textAlign: TextAlign.center),
          ],
        ),):ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context,index){
              final verse = bookmarks[index];
              final currentBook = books.value?.firstWhere((element) => element.bookNumber==verse.bookNumber,orElse: ()=>BibleNamesModel());
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 9),
                    child: CircleAvatar(
                      maxRadius: 17,
                      backgroundColor: Colors.primaries[verse.colorIndex!].withOpacity(0.7),),
                  ),
                  title: Html(
                    data:verse.text??'',
                    tagsList: Html.tags..addAll(['pb','t','j','s']),
                    style:{
                      '*':Style(
                        fontSize: FontSize(ref.watch(fontSizeProvider)-2),
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
                  subtitle: Text('${currentBook?.longName??''} ${verse.chapter}:${verse.verse}'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: IconButton(
                      onPressed: (){
                        ref.read(bookmarksStateProvider.notifier).removeBookmark(verse: verse);
                      },
                      icon: Icon(Icons.delete,color: Colors.red.withOpacity(0.5)),
                    ),
                  ),
                ),
              );
            }),
        bottomNavigationBar: const NativeBannerAdWidget(),
      ),
    );
  }
}
