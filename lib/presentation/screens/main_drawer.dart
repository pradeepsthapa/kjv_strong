import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kjv_strong/presentation/screens/search_screen.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'highlights_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Stack(
            children: [
              ColorFiltered(
                  colorFilter: ColorFilter.mode(Theme.of(context).primaryColor.withOpacity(0.5), BlendMode.overlay),
                  child: Image.asset('assets/images/feature.jpg',fit: BoxFit.cover,height: 148,width: double.infinity,)),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.3),
                          Colors.black12,
                        ],begin: Alignment.topCenter,end: Alignment.bottomCenter
                    )
                ),
                height: 148,
              ),
            ],
          ),
          // ExpansionTile(
          //   initiallyExpanded: true,
          //
          //   title: const Text("Color Theme",style: TextStyle(fontSize: 13),),
          //   children: [
          //     Consumer(
          //         builder: (context, ref, child) {
          //           final colorIndex = ref.watch(appColorProvider);
          //           return Padding(
          //             padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 12),
          //             child: Wrap(
          //                 children: Colors.primaries.map((e) =>
          //                     InkWell(
          //                       borderRadius: BorderRadius.circular(3),
          //                       splashFactory: InkRipple.splashFactory,
          //                       onTap: (){
          //                         ref.read(boxStorageProvider).saveBackground(Colors.primaries.indexOf(e));
          //                       },
          //                       child: Container(
          //                         padding: const EdgeInsets.all(1),
          //                         height: 33,width: 33,
          //                         decoration:BoxDecoration(
          //                             shape: BoxShape.circle,
          //                             border: colorIndex==Colors.primaries.indexOf(e)?Border.all(width: 1,color: e):null
          //                         ),
          //                         child: Container(
          //                           margin: const EdgeInsets.all(1),
          //                           decoration: BoxDecoration(
          //                               shape: BoxShape.circle,
          //                               color: e),),),
          //                     )).toList()),
          //           );
          //         }
          //     )],
          // ),
          ListTile(
            dense: true,
            title: const Text("Strong's Words"),
            subtitle: const Text("View all strong words"),
            trailing: const Icon(Icons.chevron_right),
            onTap: (){
              showSearch(context: context, delegate: SearchDictionaryDefinitions());
            },
          ),
          const Divider(height: 0,thickness: 0.7),
          ListTile(
            dense: true,
            title: const Text("Highlights"),
            subtitle: const Text("Show highlights or bookmarks"),
            trailing: const Icon(Icons.chevron_right),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const BookmarkScreen()));
            },
          ),
          const Divider(height: 0,thickness: 0.7),
          ListTile(
            dense: true,
            title: const Text("Share"),
            subtitle: const Text("Share this app with friends"),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()async{
              const String text = 'https://play.google.com/store/apps/details?id=com.ccbc.kjv_strong';
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              Share.share(text,sharePositionOrigin: renderBox.localToGlobal(Offset.zero)&renderBox.size);
            },
          ),
          const Divider(height: 0,thickness: 0.7),
          ListTile(
            dense: true,
            title: const Text("More Apps"),
            subtitle: const Text("Explore more similar Bible apps"),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()async{
              const url = 'https://play.google.com/store/apps/developer?id=pTech';
              if (!await launchUrl(Uri.parse(url),mode: LaunchMode.externalNonBrowserApplication)) throw 'Could not launch $url';
            },
          ),
          const Divider(height: 0,thickness: 0.7),
          ListTile(
            dense: true,
            title: const Text("Privacy"),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()async{
              const url = 'https://calvaryposts.com/kjv-strongs-concordance/';
              if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
            },
          ),
          const Divider(height: 0,thickness: 0.7),
          ListTile(
            dense: true,
            title: const Text("Exit"),
            trailing: const Icon(Icons.chevron_right),
            onTap: (){
              SystemNavigator.pop();
            },
          ),
          const Divider(height: 0,thickness: 0.7),
        ],
      ),
    );
  }
}
