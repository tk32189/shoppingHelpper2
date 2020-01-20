import 'dart:convert';

import 'package:flutter/gestures.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:showpinghelper/datatable/orderDTO.dart';
import 'package:showpinghelper/datatable/resultDataDTO.dart';
import 'package:showpinghelper/core/coreLibrary.dart';

Widget AddUserInfo(BuildContext context, ResultData inputData) {
  ResultData resultData = new ResultData();
  String userId = "";
  String nickName = "";

  /*--------------------------
  // name : ValidationCheck
  // title : 신규등록 validation check
  // desc : 
  ---------------------------*/
  void ValidationCheck(String userId) {}

  /*--------------------------
  // name : UserIdDupCheck
  // title : 사용자 아이디 중복을 체크한다.
  // desc : 
  ---------------------------*/
  Future<String> UserIdDupCheck(
      String userId, BuildContext buildContext) async {
    var map = new Map<String, dynamic>();

    if (userId != null && userId != "") {
      map["usrId"] = userId;
    }

    dynamic result = await CallService(buildContext, "SelectUser", map);
    print(result);

    if (result != null) {
      if (result.containsKey("userData")) {
        String resultString = result["userData"].toString();
        var titleList = json.decode(resultString);
        if (titleList != null && titleList.length > 0) {
          ShowMessageBox(context, "확인", "중복된 아이디가 존재합니다.");
          return "N";
        }
      }
    }
    return "Y";
  }

  /*--------------------------
  // name : SaveUserId
  // title : 사용자 아이디를 저장한다.
  // desc : 
  ---------------------------*/
  Future<String> SaveUserId(
      String userId, String nickName, BuildContext buildContext) async {
    var map = new Map<String, dynamic>();

    if (userId != null && userId != "") {
      map["usrId"] = userId;
    }

    if ( nickName != null && nickName != ""){
      map["nickName"] = nickName;
    }

    dynamic result = await CallService(buildContext, "SaveUser", map);
    print(result);
    return "Y";
  }

  return SafeArea(
    top: false,
    bottom: false,
    child: Form(
      // key: _formKey,
      //autovalidate: _autovalidate,
      //onWillPop: _warnUserAboutInvalidData,
      child: Scrollbar(
        child: SingleChildScrollView(
          dragStartBehavior: prefix0.DragStartBehavior.down,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Card(
                margin: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    // Text(
                    //   '신규등록',
                    //   textAlign: TextAlign.left,
                    //   style:
                    //       TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    TextFormField(
                      //initialValue: ordrcnt,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.person_pin,
                          color: Colors.black45,
                          size: 40,
                        ),
                        prefixStyle: TextStyle(color: Colors.red),
                        labelText: '아이디',
                        suffixStyle: TextStyle(color: Colors.green),
                      ),
                      onChanged: (String value) {
                        userId = value;
                      },
                      maxLines: 1,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //initialValue: ordrcnt,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.nature_people,
                          color: Colors.black45,
                          size: 40,
                        ),
                        prefixStyle: TextStyle(color: Colors.red),
                        labelText: '닉네임',
                        suffixStyle: TextStyle(color: Colors.green),
                      ),
                      onChanged: (String value) {
                        nickName = value;
                      },
                      maxLines: 1,
                    ),
                    RaisedButton(
                      color: Colors.red[300],
                      child: Text("저장", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (userId == null || userId.length == 0) {
                          //AMessageBoxShow(context, "아이디를 입력해 주세요");
                          ShowMessageBox(context, "확인", "아이디를 입력해 주세요");
                        }

                        UserIdDupCheck(userId, context).then((String onValue) {
                          if (onValue == "Y") {
                            //사용가능함. 신규등록필요..
                            SaveUserId(userId, nickName, context).then((String onValue){
                              if ( onValue == "Y"){
                                resultData.resultState = ResultState.yes;
                                resultData.resultString = userId;
                                //resultData.resultObject = order;
                                  Navigator.pop<ResultData>(context, resultData); //close the popup
                              }
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    ),
  );
}
