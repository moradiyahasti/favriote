// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

List<Empty> emptyFromJson(String str) => List<Empty>.from(json.decode(str).map((x) => Empty.fromJson(x)));

String emptyToJson(List<Empty> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Empty {
  int userId;
  int id;
  String title;
  bool completed;

  Empty({
   required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Empty.fromJson(Map<String, dynamic> json) => Empty(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed,
  };
}
