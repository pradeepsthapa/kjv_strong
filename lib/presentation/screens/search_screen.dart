import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/data/dictionary_words_model.dart';
import 'package:kjv_strong/logics/providers.dart';
import 'package:kjv_strong/presentation/widgets/strong_definition_widget.dart';
import 'package:kjv_strong/presentation/widgets/strongs_word_viewer_widget.dart';
import 'package:selectable/selectable.dart';

class SearchDictionaryDefinitions extends SearchDelegate {

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.close),
        onPressed: (){
          query='';
        })];
  }

  @override
  String? get searchFieldLabel => "Search Strong's Words";

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), onPressed: () {
      close(context, null);
    },);
  }

  @override
  Widget buildResults(BuildContext context) {

    if(query.isEmpty){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("🔍",style: TextStyle(fontSize: 30),),
            const SizedBox(height: 10,),
            Text("No Results",style: TextStyle(fontSize: 30,color: Colors.grey[500],fontWeight: FontWeight.w500),),
          ],
        ),
      );
    }
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return ref.watch(dictionaryWordsProvider).when(
            data: (words){
              List<DictionaryWordModel> filteredList = words.where((element) => element.topic!.toLowerCase().contains(query.toLowerCase())).toList();
              if(filteredList.isEmpty){
                return ListView.separated(
                  itemCount: words.length,
                  itemBuilder: (ctx,index){
                    return ListTile(
                      dense: true,
                      title: Text(words[index].topic??'',style: TextStyle(fontWeight: FontWeight.bold,fontSize: ref.watch(fontSizeProvider)),),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: (){
                        SingleStrongWordViewerDialog.singleShowDictionaryWordDialog(word: words[index], context: context);
                        // Navigator.push(context, MaterialPageRoute(builder: (_)=>SingleDescriptionScreen(definition: words[index])));
                      },
                    );
                  }, separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 0,thickness: 0.7);
                },);
              }
              return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (ctx,index){
                    final word = filteredList[index];
                    return Card(
                      shadowColor: Colors.black45,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        dense: true,
                        title: Text(filteredList[index].topic??'',style: TextStyle(fontSize: ref.watch(fontSizeProvider)+3,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary)),
                        subtitle: Selectable(
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
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  });
            },
            error: (error,st)=>Center(child: Text(error.toString())),
            loading: ()=>const CircularProgressIndicator());
      },);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(
        builder: (context,ref,child){
          return ref.watch(dictionaryWordsProvider).when(
              data: (words){
                List<DictionaryWordModel> filteredList = words.where((element) => element.topic!.toLowerCase().contains(query.toLowerCase())).toList();
                if(filteredList.isEmpty){
                  return ListView.separated(
                    itemCount: words.length,
                    itemBuilder: (ctx,index){
                      return ListTile(
                        dense: true,
                        title: Text(words[index].topic??'',style: TextStyle(fontWeight: FontWeight.bold,fontSize: ref.watch(fontSizeProvider)),),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: (){
                          query = filteredList[index].topic??'';
                          showResults(context);
                        },
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return const Divider(height: 0,thickness: 0.7);
                  },);
                }
                return ListView.separated(
                  itemCount: filteredList.length,
                  itemBuilder: (ctx,index){
                    return ListTile(
                      dense: true,
                      title: Text(filteredList[index].topic??'',style: TextStyle(fontSize: ref.watch(fontSizeProvider),fontWeight: FontWeight.bold),),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: (){
                        query = filteredList[index].topic??'';
                        showResults(context);
                      },
                    );
                  }, separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 0,thickness: 0.7);
                },);
              },
              error: (error,st)=>Center(child: Text(error.toString())),
              loading: ()=>const CircularProgressIndicator());
        });
  }
}