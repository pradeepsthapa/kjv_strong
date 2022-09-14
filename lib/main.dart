import 'package:animations/animations.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kjv_strong/presentation/screens/bible_loaded_screen.dart';
import 'package:kjv_strong/presentation/screens/main_drawer.dart';
import 'package:kjv_strong/presentation/widgets/custom_appbar.dart';
import 'package:kjv_strong/presentation/widgets/facebook_banner.dart';
import 'data/constants.dart';
import 'logics/providers.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // await Wakelock.enable();
  FacebookAudienceNetwork.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final font = ref.watch(globalFontProvider);
    final globalFont = Constants.globalFonts[font];
    return MaterialApp(
      title: 'KJV Strong',
      themeMode: ref.watch(boxStorageProvider).isDark?ThemeMode.dark:ThemeMode.light,
      darkTheme: ThemeData.dark().copyWith(
          primaryTextTheme: globalFont.textTheme.copyWith(
            headline6: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
            bodyText1: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
          ),
          textTheme: globalFont.textTheme.copyWith(
            overline: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
            bodyText2: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
            bodyText1: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
            subtitle1: TextStyle(
                color: Colors.white,
                fontFamily: globalFont.fontFamily),
            caption: TextStyle(
              color: Colors.white70,
              fontFamily: globalFont.fontFamily,
            ),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.vertical,
            ),
          })),
      theme: ThemeData(
          primarySwatch: Colors.brown,
          fontFamily: globalFont.fontFamily,
          textTheme: globalFont.textTheme,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.vertical,
            ),
          })
      ),
      home: const Material(child: HomePage()),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(boxStorageProvider).loadInitials();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dbState = ref.watch(dbProvider);
    return dbState.when(
        data: (data){
          return WillPopScope(
            onWillPop: () async{
              ref.read(interstitialAdProvider).showExitAd();
              return false;
            },
            child: Scaffold(
                drawer: const MainDrawer(),
                appBar: PreferredSize(preferredSize: const Size.fromHeight(50),
                    child: CustomAppBar(dbState: data)),
                body: Container(
                    color: Colors.deepOrange.withOpacity(0.05),
                    child: BibleLoadedScreen(dbState: data)),
              bottomNavigationBar: const FacebookBannerWidget(),
            ),
          );
        },
        error: (err,st)=> const Center(child: CircularProgressIndicator(),),
        loading: ()=>const Center(child: CircularProgressIndicator(),));
  }
}
