import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showpinghelper/core/popup.dart';
import 'package:showpinghelper/core/popup_content.dart';
import 'package:showpinghelper/datatable/resultDataDTO.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';



class CoreLibrary {
  static String userId = ""; //
  static bool isTestServer = true;

  static String colorBrown = "#442C2E";

  /*--------------------------
  // name : AuthRead
  // title : 사용자 확인용 아이디 조회
  // desc : 
  ---------------------------*/
  Future AuthRead() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return await File(dir.path + '/ShoppingHelperAuth.txt').readAsString();
    } catch (e) {
      return 0;
    }
  }

  /*--------------------------
  // name : AuthWrite
  // title : 사용자 확인용 아이디 저장
  // desc : 
  ---------------------------*/
  Future AuthWrite(String value) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(dir.path + '/ShoppingHelperAuth.txt').writeAsString(value.toString());
  }
}

String url = "http://10.0.2.2:3000/";
String urlTestServer = "http://10.0.2.2:3000/";
String urlServer = "http://shoppinghelper.cafe24app.com/";


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
          backgroundColor: HexColor("#FFF6F4"),
          appBar: AppBar(
            title: Text(title, style: GoogleFonts.jua(
              textStyle: TextStyle(color: HexColor("#442C2E"))
            ),),
            backgroundColor: HexColor("FEDBD0"),
            leading: new Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.arrow_back, color: HexColor("#442C2E"),),
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
Future<dynamic> CallService(
    BuildContext buildContext, String connectKey, Map body) async {


      
        //buildContext.dependOnInheritedWidgetOfExactType()
      
      

      if ( CoreLibrary.isTestServer == true){
          url = urlTestServer;
      }
      else{
        url = urlServer;
      }

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
dynamic CallServiceSync(
    BuildContext buildContext, String connectKey, Map body) async {

      if ( CoreLibrary.isTestServer == true){
          url = urlTestServer;
      }
      else{
        url = urlServer;
      }


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

/*--------------------------
  // name : AMessageBoxShow
  // title : 스낵바를 표시한다.( ShowSnackBar 와 동일기능)
  // desc : 
  ---------------------------*/
void AMessageBoxShow(BuildContext buildContext, String message)
{
  ShowSnackBar(buildContext, message);
}

/*--------------------------
  // name : DateToString
  // title : 날짜타입을 StringType으로 변경한다.
  // desc : 
  ---------------------------*/
String DateToString(DateTime date) {
  var formatter = new DateFormat('yyyyMMdd');
  String formatted = formatter.format(date);
  return formatted;
}

/*--------------------------
  // name : DateToStringForDisplay
  // title : 날짜타입을 StringType으로 변경한다.
  // desc : 
  ---------------------------*/
String DateToStringForDisplay(DateTime date) {
  var formatter = new DateFormat('yyyy-MM-dd');
  String formatted = formatter.format(date);
  return formatted;
}

/*--------------------------
  // name : StringToDisplayDate
  // title : String을 날짜형태의 스트링으로 변경한다.
  // desc : 
  ---------------------------*/
String StringToDisplayDate(String value) {
  if (value != null && value.length == 8) {
    return value.substring(0, 4) +
        "-" +
        value.substring(4, 6) +
        "-" +
        value.substring(6, 8);
  } else
    return "";
}

/*--------------------------
  // name : ShowMessageBox
  // title : 메시지 박스를 호출한다.
  // desc : 
  ---------------------------*/
Future<void> ShowMessageBox(
    BuildContext context, String title, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> ShowMessageBoxWithConfirm(
    BuildContext context, String title, String message) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: const Text('취소'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

