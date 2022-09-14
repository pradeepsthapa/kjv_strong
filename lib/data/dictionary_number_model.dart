import 'dart:convert';

List<DictionaryNumberModel> dictionaryNumberModelFromJson(String str) => List<DictionaryNumberModel>.from(json.decode(str).map((x) => DictionaryNumberModel.fromJson(x)));
String dictionaryNumberModelToJson(List<DictionaryNumberModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DictionaryNumberModel {
  DictionaryNumberModel({
    this.groupId,
    this.strongNumber,
  });

  int? groupId;
  String? strongNumber;

  factory DictionaryNumberModel.fromJson(Map<String, dynamic> json) => DictionaryNumberModel(
    groupId: json["group_id"],
    strongNumber: json["strong_number"],
  );

  Map<String, dynamic> toJson() => {
    "group_id": groupId,
    "strong_number": strongNumber,
  };
}
