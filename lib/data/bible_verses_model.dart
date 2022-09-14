import 'dart:convert';

List<BibleVersesModel> bibleVersesModelFromJson(String str) => List<BibleVersesModel>.from(json.decode(str).map((x) => BibleVersesModel.fromJson(x)));
String bibleVersesModelToJson(List<BibleVersesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BibleVersesModel {
  BibleVersesModel({
    this.bookNumber,
    this.chapter,
    this.text,
    this.verse,
    this.colorIndex
  });

  int? bookNumber;
  int? chapter;
  String? text;
  int? verse;
  int? colorIndex;

  factory BibleVersesModel.fromJson(Map<String, dynamic> json) => BibleVersesModel(
      bookNumber: json["book_number"],
      chapter: json["chapter"],
      text: json["text"],
      verse: json["verse"],
      colorIndex: json["color"]
  );

  Map<String, dynamic> toJson() => {
    "book_number": bookNumber,
    "chapter": chapter,
    "text": text,
    "verse": verse,
    "color":colorIndex
  };

  BibleVersesModel copyWith({
    int? bookNumber,
    int? chapter,
    String? text,
    int? verse,
    int? colorIndex,
  }) {
    return BibleVersesModel(
      bookNumber: bookNumber ?? this.bookNumber,
      chapter: chapter ?? this.chapter,
      text: text ?? this.text,
      verse: verse ?? this.verse,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}
