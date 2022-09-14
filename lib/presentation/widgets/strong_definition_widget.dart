import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/data/dictionary_words_model.dart';
import 'package:kjv_strong/logics/providers.dart';
import 'package:kjv_strong/presentation/widgets/strongs_word_viewer_widget.dart';
import 'package:selectable/selectable.dart';

class SingleStrongWordViewerDialog{

  static void singleShowDictionaryWordDialog({required DictionaryWordModel word, required BuildContext context}) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 240),
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
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *.7,
                  width: MediaQuery.of(context).size.width *.8,
                  child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: AppBar(
                          title: Text(word.topic??''),
                        ),
                      ),
                      body: _DictionaryWordDisplayScreen(word: word)),
                ),
              ),
            ),
          );
        });
  }
}

class _DictionaryWordDisplayScreen extends ConsumerWidget {
  final DictionaryWordModel word;
  const _DictionaryWordDisplayScreen({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Selectable(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text("Word: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: ref.watch(fontSizeProvider)),),
                Text(word.shortDefinition??'',style: TextStyle(fontSize: ref.watch(fontSizeProvider)),),
              ],
            ),
            Wrap(
              children: [
                Text("Pronunciation: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: ref.watch(fontSizeProvider)),),
                Text(word.pronunciation??'',style: TextStyle(fontSize: ref.watch(fontSizeProvider)),),
              ],
            ),
            Wrap(
              children: [
                Text("Transliteration: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: ref.watch(fontSizeProvider)),),
                Text(word.transliteration??'',style: TextStyle(fontSize: ref.watch(fontSizeProvider)),),
              ],
            ),
            const SizedBox(height: 12,),
            Text("Definition:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: ref.watch(fontSizeProvider)),),
            Html(
              data:word.definition??'',
              style:{
                '*':Style(
                  fontSize: FontSize(ref.watch(fontSizeProvider)),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                ),
              },
              onLinkTap: (url, _, __, ___) {
                StrongWordViewerDialog.showDictionaryWordDialog(word: url??'', context: context, isNT: false);
              },
            ),
          ],
        ),
      ),
    );
  }
}