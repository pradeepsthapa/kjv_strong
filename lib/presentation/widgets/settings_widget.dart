import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/data/constants.dart';
import 'package:kjv_strong/data/font_model.dart';
import 'package:kjv_strong/logics/providers.dart';
import 'font_slider_widget.dart';

class SettingWidget{
  static void showSettingsDialog({required BuildContext context}){
    showModal(
        context: context,
        configuration: FadeScaleTransitionConfiguration(
            transitionDuration: const Duration(milliseconds: 300),
            barrierColor: Colors.black.withOpacity(0.3),
            barrierDismissible: true),
        builder: (_) {
          return Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        return SwitchListTile(
                            dense: true,
                            title: const Text("Dark Mode"),
                            value: Theme.of(context).brightness==Brightness.dark,
                            onChanged: (value){
                              ref.read(boxStorageProvider).changeDarkTheme(value);
                            });
                      },
                    ),
                    const Divider(height: 0,thickness: 0.7,),
                    Consumer(
                      builder: (context, ref, child) {
                        return CheckboxListTile(
                            checkColor: Theme.of(context).brightness==Brightness.dark?Colors.black:null,
                            dense: true,
                            title: const Text("Show References"),
                            subtitle: const Text("Toggle on or off reference verses"),
                            value: ref.watch(alwaysShowCommentaryProvider),
                            onChanged: (value){
                              ref.watch(boxStorageProvider).saveAlwaysShowCommentary(value??false);
                            });
                      },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return CheckboxListTile(
                            checkColor: Theme.of(context).brightness==Brightness.dark?Colors.black:null,
                            dense: true,
                            title: const Text("Show Strong's Numbers"),
                            subtitle: const Text("Toggle on or off Strong's numbers"),
                            value: ref.watch(showStrongNumberProvider),
                            onChanged: (value){
                              ref.read(showStrongNumberProvider.state).state = value!;
                              // ref.watch(boxStorageProvider).saveAlwaysShowCommentary(value??false);
                            });
                      },
                    ),
                    const Divider(height: 0,thickness: 0.7,),
                    Consumer(builder: (context, ref, child) {
                      return ListTile(
                        title: const Text("Display Font"),
                        trailing: const Icon(Icons.chevron_right),
                        subtitle: Text(Constants.globalFonts[ref.watch(globalFontProvider.notifier).state].fontName??''),
                        onTap: (){
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                            pageBuilder: (context, anim1, anim2) {
                              return AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: ()=>Navigator.pop(context),
                                      child: const Text("Cancel")),
                                ],
                                contentPadding: EdgeInsets.zero,
                                scrollable: true,
                                title: Text("Select Font",style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                content: SingleChildScrollView(
                                  child: Consumer(
                                      builder: (context,ref, child) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: Constants.globalFonts.map((e) => RadioListTile<GlobalFontModel>(
                                            dense: true,
                                            title: Text(e.fontName??'',style: TextStyle(fontFamily: e.fontFamily),),
                                            groupValue: Constants.globalFonts[ref.watch(globalFontProvider)],
                                            value: e,
                                            onChanged: (value){
                                              final fontIndex = Constants.globalFonts.indexOf(value!);
                                              ref.read(boxStorageProvider).saveFontStyle(fontIndex);
                                              Navigator.pop(context);
                                            },
                                          )).toList(),
                                        );
                                      }
                                  ),
                                ),
                              );
                            },);
                        },
                      );
                    },),
                    const Divider(height: 0,thickness: 0.7,),
                    const FontSliderWidget(),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: TextButton(onPressed: (){
                    //     Navigator.pop(context);
                    //   }, child: Text("Close",style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
                    // )
                  ],
                ),
              ));
        });
  }
}