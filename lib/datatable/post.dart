import 'package:json_annotation/json_annotation.dart';

class Post {
  final String userId;
  final int id;
  final String title;
  final String body;
  final String compCd;

  Post({this.userId, this.id, this.title, this.body, this.compCd});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      compCd: json['COMP_CD'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = userId;
    map["title"] = title;
    map["body"] = body;

    return map;
  }
}