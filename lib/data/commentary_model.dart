import 'dart:convert';

List<CommentaryModel> commentaryModelFromJson(String str) => List<CommentaryModel>.from(json.decode(str).map((x) => CommentaryModel.fromJson(x)));
String commentaryModelToJson(List<CommentaryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentaryModel {
  CommentaryModel({
    this.bookNumber,
    this.chapterNumberFrom,
    this.chapterNumberTo,
    this.marker,
    this.text,
    this.verseNumberFrom,
    this.verseNumberTo,
  });

  int? bookNumber;
  int? chapterNumberFrom;
  int? chapterNumberTo;
  dynamic marker;
  String? text;
  int? verseNumberFrom;
  int? verseNumberTo;

  factory CommentaryModel.fromJson(Map<String, dynamic> json) => CommentaryModel(
    bookNumber: json["book_number"],
    chapterNumberFrom: json["chapter_number_from"],
    chapterNumberTo: json["chapter_number_to"],
    marker: json["marker"],
    text: json["text"],
    verseNumberFrom: json["verse_number_from"],
    verseNumberTo: json["verse_number_to"],
  );

  Map<String, dynamic> toJson() => {
    "book_number": bookNumber,
    "chapter_number_from": chapterNumberFrom,
    "chapter_number_to": chapterNumberTo,
    "marker": marker,
    "text": text,
    "verse_number_from": verseNumberFrom,
    "verse_number_to": verseNumberTo,
  };
}
