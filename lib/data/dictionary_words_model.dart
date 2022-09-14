

import 'dart:convert';

List<DictionaryWordModel> dictionaryWordModelFromJson(String str) => List<DictionaryWordModel>.from(json.decode(str).map((x) => DictionaryWordModel.fromJson(x)));
String dictionaryWordModelToJson(List<DictionaryWordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DictionaryWordModel {
  DictionaryWordModel({
    this.definition,
    this.lexeme,
    this.pronunciation,
    this.shortDefinition,
    this.topic,
    this.transliteration,
  });

  String? definition;
  String? lexeme;
  String? pronunciation;
  String? shortDefinition;
  String? topic;
  String? transliteration;

  factory DictionaryWordModel.fromJson(Map<String, dynamic> json) => DictionaryWordModel(
    definition: json["definition"],
    lexeme: json["lexeme"],
    pronunciation: json["pronunciation"],
    shortDefinition: json["short_definition"],
    topic: json["topic"],
    transliteration: json["transliteration"],
  );

  Map<String, dynamic> toJson() => {
    "definition": definition,
    "lexeme": lexeme,
    "pronunciation": pronunciation,
    "short_definition": shortDefinition,
    "topic": topic,
    "transliteration": transliteration,
  };
}
