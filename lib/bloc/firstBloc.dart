import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:showpinghelper/core/coreLibrary.dart';
import 'package:showpinghelper/datatable/orderDTO.dart';
import 'package:showpinghelper/datatable/orderDTO.dart' as prefix0;
import 'package:showpinghelper/datatable/post.dart';
import 'package:showpinghelper/datatable/resultDataDTO.dart';
import 'package:showpinghelper/popup/itemAdd.dart';

class FirstBloc {
  List<OrderDTO> orderList = new List<OrderDTO>();

  final _orderSubject = BehaviorSubject<List<OrderDTO>>();
  final _titleNmSubJect = BehaviorSubject<String>();
  //final _stodNoSubject = BehaviorSubject<String>();
  Stream<List<OrderDTO>> get resultList => _orderSubject.stream;
  Stream<String> get getTitleNm => _titleNmSubJect.stream;
  setTitleNm(String titleNm) {
    _titleNmSubJect.add(titleNm);
  }

  BuildContext buildContext;

  String get getStodNo => stodNo;

  String userId = "D930004";
  String stodNo = "";

  //String titleNm = "";

  String url = "http://10.0.2.2:3000/";

  FirstBloc() {
    OrderDTO dto = new OrderDTO();
    dto.ordrNo = "1";
    dto.rowIndex = "1";
    dto.ordrNm = "강아지사료";
    dto.ordrCd = "CD1";
    dto.ordrDirectDt = "20190507";
    dto.vistSn = "1";
    dto.subOrdrNm = " ";
    dto.ordrCnt = "1";

    orderList.add(dto);

    dto = new OrderDTO();
    dto.ordrNo = "2";
    dto.rowIndex = "2";
    dto.ordrNm = "커피";
    dto.ordrCd = "CD2";
    dto.ordrDirectDt = "20190507";
    dto.vistSn = "1";
    dto.subOrdrNm = " ";
    dto.ordrCnt = "1";

    orderList.add(dto);

    _orderSubject.add(orderList);

    if (this.userId != null && this.userId != "") {
      this.SelectLastStodNo(this.userId); //마지막 stodNO조회
    }
  }

/*--------------------------
  // title : 리스트 뷰 클릭시
  // desc :
  ---------------------------*/
  void ListViewClick(OrderDTO dto, String mode, BuildContext context) {
    if (dto == null) return;

    if (mode == "get") //구매함.
    {
      if (dto.buyYn == "Y") {
        dto.buyYn = "N";
        //dto.isBuy = false;
      } else {
        dto.buyYn = "Y";
        //dto.isBuy = true;
      }
    } else if (mode == "delete") //삭제
    {
      orderList.remove(dto);
    } else if (mode == "edit") //수정
    {
      ItemAddPopupOpen(dto, context);
    }

    _orderSubject.add(orderList);
  }

  /*--------------------------
  // name : ItemAddPopupOpen
  // title : 아이템 추가 팝업 호출.
  // desc : 
  ---------------------------*/
  void ItemAddPopupOpen(OrderDTO orderDto, BuildContext context) {
    ResultData inputData = new ResultData();
    if (orderDto != null) {
      inputData.resultObject = orderDto;
    }

    Widget itemPopup = ItemAddPopup(context, inputData);

    showPopup(context, itemPopup, "쇼핑상품 추가").then<void>((Object value) {
      if (value != null) {
        ResultData resultData = value as ResultData;
        OrderDTO row = resultData.resultObject as OrderDTO;
        this.AddOrder(row);
      }
    });
  }

  static String vistSn = "1";
  static int newOrdrNoCount = 0;
  /*--------------------------
  // name : AddOrder
  // title : 아이템을 추가한다.
  // desc : 
  ---------------------------*/
  void AddOrder(OrderDTO row) {
    if (row == null) return;

    if (row.ordrNo != null && row.ordrNo.isNotEmpty) {
      //수정된 데이터 리턴된 경우
      for (int i = 0; i < orderList.length; i++) {
        OrderDTO item = orderList[i];
        if (item.ordrNo == row.ordrNo) {
          item.ordrNm = row.ordrNm;
          item.ordrCd = row.ordrCd;
          item.ordrDirectDt = DateTime.now().toString();
          item.vistSn = vistSn;
          item.subOrdrNm = row.subOrdrNm;
          item.ordrCnt = row.ordrCnt;
          item.rmrkCnte = row.rmrkCnte;
          item.exptPrice = row.exptPrice;
          break;
        } else {
          continue;
        }
      }
    } else {
      OrderDTO newRow = new OrderDTO();
      //dto = new OrderDTO();
      newRow.ordrNo = MakeNewOrderNo("new");
      newRow.ordrNm = row.ordrNm;
      newRow.ordrCd = row.ordrCd;
      newRow.ordrDirectDt = DateTime.now().toString();
      newRow.vistSn = vistSn;
      newRow.subOrdrNm = row.subOrdrNm;
      newRow.ordrCnt = row.ordrCnt;
      newRow.rmrkCnte = row.rmrkCnte;
      newRow.exptPrice = row.exptPrice;

      orderList.add(newRow);

      MakeRowIndex(orderList);
    }

    _orderSubject.add(orderList);
  }

  /*--------------------------
  // name : MakeNewOrderNo
  // title : 신규 처방번호를 생성한다.
  // desc : 
  ---------------------------*/
  String MakeNewOrderNo(String preFix) {
    newOrdrNoCount = newOrdrNoCount + 1;
    return preFix + newOrdrNoCount.toString();
  }

  /*--------------------------
  // name : MakeRowIndex
  // title : Rowindex를 새로 만든다.
  // desc : 
  ---------------------------*/
  void MakeRowIndex(List<OrderDTO> orderList) {
    if (orderList != null && orderList.length > 0) {
      for (int i = 0; i < orderList.length; i++) {
        orderList[i].rowIndex = (i.toInt() + 1).toString();
      }
    }
  }

  void SelectData() {
    //SaveData();
  }

  void OnSaveData(Map<String, dynamic> titleInfo) {
    SaveData(titleInfo);
  }

  void OnSelectData() {
    //this.SelectShowingData(this.userId, this.stodNo);
    if (this.userId != null && this.userId != "") {
      this.SelectLastStodNo(this.userId); //마지막 stodNO조회
    }
  }

  /*--------------------------
  // name : OnNewShoping
  // title : 신규등록
  // desc : 
  ---------------------------*/
  void OnNewShoping() {
    this.stodNo = ""; //신규처방으로..
    this.orderList = new List<OrderDTO>();
    this._orderSubject.add(orderList);
    this._titleNmSubJect.add("");
  }

  /*--------------------------
  // name : SelectTitleInfo
  // title : stodNo에 해당하는 데이터를 조회한다.
  // desc : 
  ---------------------------*/
  void SelectTitleInfo(String stodNo)
  {
    this.SelectShowpingData(this.userId, stodNo);
  }

  /*--------------------------
  // name : SelectLastStodNo
  // title : 마지막 저장된 stodNo 조회 및 쇼핑리스트를 조회한다.
  // desc : 
  ---------------------------*/
  Future<OrderDTO> SelectLastStodNo(String userId) async {
    var map = new Map<String, dynamic>();

    if (userId != null && userId != "") {
      map["usrId"] = userId;
    }

    // if (stodNo != null && stodNo != "") {
    //   map["stodNo"] = stodNo;
    // }

    CallService("SelectLastStodNo", map).then((returnValue) {
      print(returnValue);
      if (returnValue != null) {
        Map map = returnValue[0];

        if (map.containsKey("stod_no")) {
          String stodNo = map["stod_no"].toString();

          if (stodNo != "") {
            this.stodNo = stodNo;
            //마지막 저장된 내역이 있음.
            this.SelectShowpingData(this.userId, stodNo);
          }
        }
      }
    });
  }

  /*--------------------------
  // name : SelectShowingData
  // title : 쇼핑 데이터를 조회한다.
  // desc : 
  ---------------------------*/
  Future<OrderDTO> SelectShowpingData(String userId, String stodNo) async {
    var map = new Map<String, dynamic>();

    if (userId != null && userId != "") {
      map["usrId"] = userId;
    }

    if (stodNo != null && stodNo != "") {
      map["stodNo"] = stodNo;
    }

    dynamic result = await CallService("ShowpingOrdrSelect", map);
    print(result);
    //print("===================================");
    //print(json.decode(result)[0]);

    //Map resultList = json.decode(result);
    if (result != null) {
      if (result.containsKey("titleNm")) {
        _titleNmSubJect.add(result["titleNm"].toString());
      }

      if (result.containsKey("stodNo")) {
        this.stodNo = result["stodNo"].toString();
      }

      if (result.containsKey("orderData")) {
        String orderString = result["orderData"].toString();
        var orders = json.decode(orderString);
        if (orders != null && orders.length > 0) {
          List<OrderDTO> orderList = new List<OrderDTO>();
          for (int i = 0; i < orders.length; i++) {
            OrderDTO newDTO = OrderDTO.fromJson(orders[i]);
            if (newDTO != null) {
              orderList.add(newDTO);
            }
          }

          MakeRowIndex(orderList);

          this.orderList = orderList;
          _orderSubject.add(orderList);
        }
      }
    }
  }

  Future<OrderDTO> SaveData(Map<String, dynamic> titleInfo) async {
    List<OrderDTO> orderList;
    //_airSubject.stream.last.then((item)=> orderList = item);

    orderList = _orderSubject.value;

    List listBody = List();
    orderList.map((item) => listBody.add(item.toMap())).toList();
    //return jsonList;

    //List listBody = encondeToJson(orderList);

    var body = json.encode({"ListData": listBody});

    var map = new Map<String, dynamic>();
    map["ListData"] = body;

    if (titleInfo.containsKey("titlNm")) {
      map["titlNm"] = titleInfo["titlNm"];
    }
    //map["titlNm"] = "임시 타이틀명";

    if (titleInfo.containsKey("userId")) {
      map["usrId"] = titleInfo["userId"];
    }
    //map["usrId"] = "D930004";
    map["ordrDirectDt"] = "";
    map["stodNo"] = this.stodNo;
    map["showDt"] = titleInfo["showDt"];

    // List jsonList = List();
    // body.map((item) => jsonList.add(item.toMap())).toList();
    //OrderDTO p = await InsertDataSingle("ShowpingOrdrSave", orderList[0].toMap());
    dynamic p = await CallService("ShowpingOrdrSave", map);

    //OrderDTO.fromJson(json.decode(response.body)[0])
    //OrderDTO p = await InsertData("ShowpingOrdrSave", body);
  }

  /*--------------------------
  // name : CallServiceMessageProcess
  // title : 서버를 갔다온 후 메시지 처리
  // desc : 
  ---------------------------*/
  dynamic CallServiceMessageProcess(String result) {
    Map resultList = json.decode(result);
    if (resultList.containsKey("message") &&
        resultList["message"].toString().length > 0) {
      this.ShowSnackBar(resultList["message"].toString());
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
  void ShowSnackBar(String message) {
    if (this.buildContext != null) {
      final snackBar = SnackBar(
          duration: Duration(milliseconds: 1000), content: Text(message));
      Scaffold.of(this.buildContext).showSnackBar(snackBar);
    }
  }

  // Future<OrderDTO> InsertData(String connectKey, String body) async {
  //   return await http
  //       .post(Uri.encodeFull(url + connectKey), body: body, headers: {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   }).then((http.Response response) {
  //     //      print(response.body);
  //     final int statusCode = response.statusCode;
  //     if (statusCode < 200 || statusCode > 400 || json == null) {
  //       throw new Exception("Error while fetching data");
  //     }
  //     return OrderDTO.fromJson(json.decode(response.body)[0]);
  //   });
  // }

  /*--------------------------
  // name : CallService
  // title : 서버 호출!!!!!!!!!!!!!!!!!
  // desc : 
  ---------------------------*/
  Future<dynamic> CallService(String connectKey, Map body) async {
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
      resultString = this.CallServiceMessageProcess(response.body);
      return resultString;
    });
  }
}
