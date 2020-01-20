import 'package:flutter/material.dart';
import 'package:showpinghelper/bloc/orderBloc.dart';
// import 'package:showpinghelper/core/popup.dart';
// import 'package:showpinghelper/core/popup_content.dart';
import 'package:showpinghelper/core/coreLibrary.dart';
import 'package:showpinghelper/datatable/post.dart';
import 'package:showpinghelper/datatable/resultDataDTO.dart';
import 'package:showpinghelper/popup/itemAdd.dart';
import 'package:showpinghelper/popup/addUserInfo.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserInfoTabState extends State<UserInfoTab> {
  /*--------------------------
  // name : NewUserPopupOpen
  // title : 신규등록 화면 팝업
  // desc : 
  ---------------------------*/
  void NewUserPopupOpen(BuildContext context) {
    ResultData inputData = new ResultData();
    // if (orderDto != null) {
    //   inputData.resultObject = orderDto;
    // }

    Widget itemPopup = AddUserInfo(context, inputData);

    showPopup(context, itemPopup, "신규등록").then<void>((Object value) {
      if (value != null) {
        ResultData resultData = value as ResultData;
        String resultString = resultData.resultString;
        if (resultString != null && resultString != "") {
          setState(() {
          CoreLibrary.userId = resultString;
          CoreLibrary core = new CoreLibrary();
          core.AuthWrite(CoreLibrary.userId);
          });
          

        }
        // this.AddOrder(row);
      }
    });
  }

  void UserInfoDisplay() {
    if (CoreLibrary.userId != null && CoreLibrary.userId.length > 0) {}
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red[100],
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: true,
                child: Container(
                  height: 30,
                  child: Text('${CoreLibrary.userId} 님 환영합니다.'),
                ),
              ),

              RaisedButton(
                child: Text("신규등록"),
                onPressed: () {
                  NewUserPopupOpen(context);
                },
              )
              // Container(
              //     child: Card(
              //   margin: EdgeInsets.all(5),
              //   child: Column(
              //     children: <Widget>[
              //       Text('신규등록', textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
              //       SizedBox(height: 10,),
              //       TextFormField(
              //         initialValue: ordrcnt,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           border: OutlineInputBorder(),
              //           prefixIcon: Icon(
              //             Icons.person_pin,
              //             color: Colors.black45,
              //             size: 40,
              //           ),
              //           prefixStyle: TextStyle(color: Colors.red),
              //           labelText: '아이디',
              //           suffixStyle: TextStyle(color: Colors.green),
              //         ),
              //         onChanged: (String value) {
              //           ordrcnt = value;
              //         },
              //         maxLines: 1,
              //       ),
              //       SizedBox(height: 10),
              //       TextFormField(
              //         initialValue: ordrcnt,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           border: OutlineInputBorder(),
              //           prefixIcon: Icon(
              //             Icons.nature_people,
              //             color: Colors.black45,
              //             size: 40,
              //           ),
              //           prefixStyle: TextStyle(color: Colors.red),
              //           labelText: '닉네임',
              //           suffixStyle: TextStyle(color: Colors.green),
              //         ),
              //         onChanged: (String value) {
              //           ordrcnt = value;
              //         },
              //         maxLines: 1,
              //       ),
              //       RaisedButton(
              //           color: Colors.red[300],
              //           child:
              //               Text("저장", style: TextStyle(color: Colors.white)),
              //           onPressed: () {

              //           },
              //         ),
              //     ],
              //   ),
              // )),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoTab extends StatefulWidget {
  final orderbloc = new OrderBloc();

  UserInfoTabState createState() => UserInfoTabState();

  @override
  Widget build(BuildContext context) {}
}
