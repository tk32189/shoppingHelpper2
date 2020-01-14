import 'package:flutter/material.dart';
import 'package:showpinghelper/core/popup.dart';
import 'package:showpinghelper/core/popup_content.dart';
import 'package:showpinghelper/datatable/resultDataDTO.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


String url = "http://10.0.2.2:3000/";


Future<Object> showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) async {
    final result = await Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title),
              backgroundColor: Colors.green[300],
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      Navigator.pop(context, "test"); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );

    return result;
  }



  /*--------------------------
  // name : CallService
  // title : 서버 호출!!!!!!!!!!!!!!!!!
  // desc : 
  ---------------------------*/
  Future<dynamic> CallService(BuildContext buildContext, String connectKey, Map body) async {
    return await http.post(Uri.encodeFull(url + connectKey),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      //      print(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      //Map resultList = json.decode(response.body);
      dynamic resultString;
      resultString = CallServiceMessageProcess(buildContext, response.body);
      return resultString;
    });
  }

  /*--------------------------
  // name : CallService
  // title : 서버 호출!!!!!!!!!!!!!!!!!
  // desc : 
  ---------------------------*/
  dynamic CallServiceSync(BuildContext buildContext, String connectKey, Map body) async {
    return await http.post(Uri.encodeFull(url + connectKey),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      //      print(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      //Map resultList = json.decode(response.body);
      dynamic resultString;
      resultString = CallServiceMessageProcess(buildContext, response.body);
      return resultString;
    });
  }

    /*--------------------------
  // name : CallServiceMessageProcess
  // title : 서버를 갔다온 후 메시지 처리
  // desc : 
  ---------------------------*/
  dynamic CallServiceMessageProcess(BuildContext buildContext, String result) {
    Map resultList = json.decode(result);
    if (resultList.containsKey("message") &&
        resultList["message"].toString().length > 0) {
      ShowSnackBar(buildContext, resultList["message"].toString());
    }

    dynamic returnValue;
    if (resultList.containsKey("resultString")) {
      returnValue = resultList["resultString"];
      //json.decode(resultList["resultString"]);
    }

    return returnValue;
  }

  /*--------------------------
  // name : ShowSnackBar
  // title : 스낵바를 표시한다.
  // desc : 
  ---------------------------*/
  void ShowSnackBar(BuildContext buildContext, String message) {
    if (buildContext != null) {
      final snackBar = SnackBar(
          duration: Duration(milliseconds: 1000), content: Text(message));
      Scaffold.of(buildContext).showSnackBar(snackBar);
    }
  }