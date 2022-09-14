import 'dart:convert';

List<BibleNamesModel> bibleNamesModelFromJson(String str) => List<BibleNamesModel>.from(json.decode(str).map((x) => BibleNamesModel.fromJson(x)));
String bibleNamesModelToJson(List<BibleNamesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BibleNamesModel {
  BibleNamesModel({
    this.bookColor,
    this.bookNumber,
    this.longName,
    this.shortName,
  });

  String? bookColor;
  int? bookNumber;
  String? longName;
  String? shortName;

  factory BibleNamesModel.fromJson(Map<String, dynamic> json) => BibleNamesModel(
    bookColor: json["book_color"],
    bookNumber: json["book_number"],
    longName: json["long_name"],
    shortName: json["short_name"],
  );

  Map<String, dynamic> toJson() => {
    "book_color": bookColor,
    "book_number": bookNumber,
    "long_name": longName,
    "short_name": shortName,
  };
}
