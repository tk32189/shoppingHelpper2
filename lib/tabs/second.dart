import 'package:flutter/material.dart';
import 'package:showpinghelper/bloc/orderBloc.dart';
// import 'package:showpinghelper/core/popup.dart';
// import 'package:showpinghelper/core/popup_content.dart';
import 'package:showpinghelper/core/coreLibrary.dart';
import 'package:showpinghelper/datatable/post.dart';
import 'package:showpinghelper/popup/itemAdd.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SecondTab extends StatelessWidget {
  static final CREATE_POST_URL = 'https://localhost:3000/roomSelect';
  Map<String, dynamic> body = {
    'list_class_type': 'ALL',
    'name': 'bob',
    'usr_id': 'test11'
  };

  final orderbloc = new OrderBloc();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red,
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                  onPressed: () {
                    orderbloc.selectData();
                  },
                  child: new Container(
                    child: new Text("data"),
                  )),
              StreamBuilder<Post>(
                  stream: orderbloc.airResult,
                  builder: (context, snapshot) {
                    var title = "";
                    if (snapshot.hasData) {
                      title = snapshot.data.compCd;
                    }
                    
                    return new RaisedButton(
                      child: new Container(
                        child: new Text(title),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void TestButtonClicked(BuildContext context, String key) {}

  // Future<Post> createPost(String url, {Map body}) async {
  //   return http.post(url, body: body).then((http.Response response) {
  //     final int statusCode = response.statusCode;

  //     if (statusCode < 200 || statusCode > 400 || json == null) {
  //       throw new Exception("Error while fetching data");
  //     }
  //     return Post.fromJson(json.decode(response.body));
  //   });
  // }

  Future<dynamic> createPost(String url, Map<String, dynamic> body) async {
    return await http.post(Uri.encodeFull(url),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      //      print(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return Post.fromJson(json.decode(response.body));
    });
  }

  
}
