import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:showpinghelper/datatable/titleDTO.dart';
import 'package:showpinghelper/core/coreLibrary.dart';
import  'dart:convert';
import 'package:showpinghelper/datatable/titleDTO.dart';

class ThrdBloc {

  
  
  List<TitleDTO> titleList = new List<TitleDTO>();

  final _titleListSubject = BehaviorSubject<List<TitleDTO>>();
  Stream<List<TitleDTO>> get getTitleList => _titleListSubject;

  BuildContext buildContext;
  //String userId = "D930004";

  final VoidCallback dataSearched;
  /*--------------------------
  // name : ThrdBloc
  // title : 생성자
  // desc : 
  ---------------------------*/
  //ThrdBloc() {}
  ThrdBloc({
    this.dataSearched
  });
  /*--------------------------
      // name : Loaded
      // title : Tab변경시
      // desc : 
      ---------------------------*/
  // void TabChanged() {
  //   this.SelectTitleList(CoreLibrary.userId);
  // }

  void DeleteTitleCall(String stodNo)
  {
    this.DeleteTitle(CoreLibrary.userId, stodNo);
  }

  /*--------------------------
      // name : DeleteTitle
      // title : 타이틀을 삭제한다.
      // desc : 
      ---------------------------*/
  Future<String> DeleteTitle(String userId, String stodNo) async{
    var map = new Map<String, dynamic>();

    if (userId != null && userId != "") {
      map["usrId"] = userId;
    }

    if (stodNo != null && stodNo != "") {
      map["stodNo"] = stodNo;
    }

    await CallService(this.buildContext, "DeleteTitle", map).then((returnValue){
      //재조회
      this.SelectTitleList(CoreLibrary.userId);
    });
  }


  /*--------------------------
      // name : SelectTitleList
      // title : 타이틀을 조회한다.
      // desc : 
      ---------------------------*/
  Future<bool> SelectTitleList(String userId) async {
    _titleListSubject.add(null);
    var map = new Map<String, dynamic>();

    if (userId != null && userId != "") {
      map["usrId"] = userId;
    }

    dynamic result = await CallService(this.buildContext, "SelectTitle", map);

    //dynamic result = CallServiceSync(this.buildContext, "SelectTitle", map);
    print(result);

    if (result != null) {
      if (result.containsKey("titlData")) {
        String resultString = result["titlData"].toString();
        var titleList = json.decode(resultString);
        if (titleList != null && titleList.length > 0) {
          List<TitleDTO> newTitleList = new List<TitleDTO>();
          for (int i = 0; i < titleList.length; i++) {
            TitleDTO newDTO = TitleDTO.fromJson(titleList[i]);
            if (newDTO != null) {
              newTitleList.add(newDTO);
            }
          }

          //MakeRowIndex(orderList);

           this.titleList = newTitleList;
           _titleListSubject.add(this.titleList);
        }
      }
    }
  }
}
