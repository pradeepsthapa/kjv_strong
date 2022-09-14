import 'package:google_fonts/google_fonts.dart';
import 'font_model.dart';

class Constants {

  static const String pageIndex = 'pageIndex';
  static const String darkMode = 'darkMode';
  static const String fontSize = 'fontSize';
  static const String backgroundColor = 'background';
  static const String fontIndex = 'fontStyle';
  static const String bibleIndex = 'bibleIndex';
  static const String chapterIndex = 'chapterIndex';
  static const String showCommentary = 'showCommentary';
  static const String bookmarks = 'bookmarks';

  static List<GlobalFontModel> globalFonts = [
    GlobalFontModel(textTheme: GoogleFonts.literataTextTheme(), fontFamily: GoogleFonts.literata().fontFamily!, fontName: "Literata"),
    GlobalFontModel(textTheme: GoogleFonts.sourceSansProTextTheme(), fontFamily: GoogleFonts.sourceSansPro().fontFamily!, fontName: "Source Sans Pro"),
    GlobalFontModel(textTheme: GoogleFonts.ibmPlexSansTextTheme(), fontFamily: GoogleFonts.ibmPlexSans().fontFamily!, fontName: "IBM Plex"),
    GlobalFontModel(textTheme: GoogleFonts.merriweatherTextTheme(), fontFamily: GoogleFonts.merriweather().fontFamily!, fontName: "Merriweather"),
    GlobalFontModel(textTheme: GoogleFonts.notoSerifTextTheme(), fontFamily: GoogleFonts.notoSerif().fontFamily!, fontName: "Noto Serif"),
    GlobalFontModel(textTheme: GoogleFonts.libreBaskervilleTextTheme(), fontFamily: GoogleFonts.libreBaskerville().fontFamily!, fontName: "Libre Baskerville"),
    GlobalFontModel(textTheme: GoogleFonts.quicksandTextTheme(), fontFamily: GoogleFonts.quicksand().fontFamily!, fontName: "Quicksand"),
    GlobalFontModel(textTheme: GoogleFonts.loraTextTheme(), fontFamily: GoogleFonts.lora().fontFamily!, fontName: "Lora"),
    GlobalFontModel(textTheme: GoogleFonts.montserratTextTheme(), fontFamily: GoogleFonts.montserrat().fontFamily!, fontName: "Montserrat"),
    GlobalFontModel(textTheme: GoogleFonts.workSansTextTheme(), fontFamily: GoogleFonts.workSans().fontFamily!, fontName: "Work Sans"),
    GlobalFontModel(textTheme: GoogleFonts.slabo13pxTextTheme(), fontFamily: GoogleFonts.slabo13px().fontFamily!, fontName: "Slabo 13px"),
  ];
}