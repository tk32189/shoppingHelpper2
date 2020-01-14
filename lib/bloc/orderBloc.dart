import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:showpinghelper/datatable/orderDTO.dart';
import 'package:showpinghelper/datatable/post.dart';

class OrderBloc {
  final _airSubject = BehaviorSubject<Post>();
  Map<String, dynamic> body = {
    'list_class_type': 'ALL',
    'name': 'bob',
    'usr_id': 'test11'
  };

  Stream<Post> get airResult => _airSubject.stream;

  //생성자
  OrderBloc() {}

  void selectData() {
    fatchData();
  }

  void fatch() async {
    // var airResult = await fatchData();
    // _airSubject.add(airResult);
  }

  Future<OrderDTO> fatchData() async {
    Post p = await createPost("http://10.0.2.2:3000/CompSelect");
    print(p.title);

    _airSubject.add(p);
  }

  Future<Post> createPost(String url) async {
    return await http.post(Uri.encodeFull(url),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      //      print(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error wh/ile fetching data");
      }
      return Post.fromJson(json.decode(response.body)[0]);
    });
  }
}
