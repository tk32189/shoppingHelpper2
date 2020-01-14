import 'package:flutter/material.dart';
import 'package:showpinghelper/bloc/firstBloc.dart';
import 'package:showpinghelper/datatable/orderDTO.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:showpinghelper/core/coreLibrary.dart';
import 'package:showpinghelper/popup/itemAdd.dart';
import 'package:showpinghelper/datatable/resultDataDTO.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

typedef ColorCallback = void Function(Color color);

class FirstTab extends StatefulWidget {
  //irstTab({Key key}) : super(key: key);
  const FirstTab({
    Key key,
  }) : super(key: key);

  @override
  FirstTabState createState() => FirstTabState();

  sendData(String message, String value) =>
      createState().onDataReceived(message, value);
}

FirstBloc firstBloc = new FirstBloc();

class FirstTabState extends State<FirstTab> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  //List<OrderDTO> orderList = new List<OrderDTO>();

  //FirstTabFul _vpc;
  BuildContext mainContext;

  void test123() {
    if (mainContext != null) {
      //showPopup(mainContext, ItemAddPopup(), "물품 추가");
    }
  }

//   onDataReceivedsingletest(String message, String value) => {
//     onDataReceived(message, value)
//   };

// //다른화면에서 전달되는 데이터 처리
//   void onDataReceivedsingle(String message)
//   {
//     print(message);
//   }

  //다른화면에서 전달되는 데이터 처리
  void onDataReceived(String message, String value) {
    if (message == "updateTitleInfo") {
      if (value != null && value.length > 0) {
        firstBloc.SelectTitleInfo(value);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  //다른 화면에서 전달되는 데이터
  void sendDataReceived(String messagId) {
    if (messagId == "ADD") {
      // if ( mainContext != null){
      //     showPopup(mainContext, ItemAddPopup(), "물품 추가");
      // }

    }
  }

  void methodInPage2() {
    if (mainContext != null) {
      //showPopup(mainContext, ItemAddPopup(), "물품 추가");
    }
  }
  DateTime showpingDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    this.mainContext = context;
    String titlNm = ""; //타이틀명
    String userId = "D930004";
    //String showpingDate = DateTime.now().toString();
    
    Key txtLabel = new Key("txtLabel");
    TextEditingController titleController = TextEditingController();
    if (firstBloc != null) {
      firstBloc.buildContext = context;
    }

    // final snackBar = SnackBar(
    //         content: Text('Yay! A SnackBar!'),
    //         action: SnackBarAction(
    //           label: 'Undo',
    //           onPressed: () {
    //             // Some code to undo the change.
    //           },
    //         ),
    //       );

    return new Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        color: Colors.red[400],
                        child:
                            Text("저장", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          var map = new Map<String, dynamic>();
                          if (titlNm == null || titlNm.length == 0) {
                            final snackBar =
                                SnackBar(content: Text('타이틀을 입력해야 합니다.'));
                            Scaffold.of(context).showSnackBar(snackBar);
                            return;
                          }

                          map["titlNm"] = titlNm;
                          map["userId"] = userId;
                          firstBloc.OnSaveData(map);
                        },
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        color: Colors.blue[400],
                        child: Text("새로 만들기",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          firstBloc.OnNewShoping();
                        },
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        color: Colors.blue[400],
                        child: Text("테스트 버튼",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(containerHeight: 210.0),
                              showTitleActions: true,
                              minTime: DateTime(2000, 1, 1),
                              maxTime: DateTime(2022, 12, 31),
                              currentTime: DateTime.now(),
                              locale: LocaleType.ko, onConfirm: (date) {
                            print(date);
                            print(date);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(containerHeight: 210.0),
                          showTitleActions: true,
                          minTime: DateTime(2000, 1, 1),
                          maxTime: DateTime(2022, 12, 31),
                          currentTime: DateTime.now(),
                          locale: LocaleType.ko, onConfirm: (date) {
                        setState(() {
                          showpingDate = date;
                        });
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 200,
                      height: 40,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            color: Colors.teal,
                          ),
                          Text(
                            "쇼핑일",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "${showpingDate.year}-${showpingDate.month}-${showpingDate.day}",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: StreamBuilder<String>(
                      stream: firstBloc.getTitleNm,
                      builder: (context, snapshot) {
                        titleController.value =
                            TextEditingValue(text: "${snapshot.data}");
                        titlNm = snapshot.data;
                        return TextFormField(
                          
                          controller: titleController,
                          //initialValue: ordrName,
                          textCapitalization: TextCapitalization.words,

                          decoration: const InputDecoration(
                            //border: UnderlineInputBorder(),
                            //filled: true,
                            
                            //icon: Icon(Icons.add_shopping_cart),
                            hintText: '쇼핑명을 입력하세요',
                            //labelText: '쇼핑명 *',
                          ),

                          onChanged: (String value) {
                            titlNm = value;
                          },
                          onFieldSubmitted: (String value) {
                            firstBloc.setTitleNm(titlNm);
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
          Flexible(
            child: StreamBuilder<List<OrderDTO>>(
                stream: firstBloc.resultList,
                builder: (context, snapshot) {
                  return Container(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data[index];
                            String ordrNm = item.ordrNm;
                            String ordrNo = item.ordrNo;
                            String rowIndex = item.rowIndex;
                            String buyYn = item.buyYn;
                            bool isBuy = buyYn == "Y" ? true : false;
                            String subOrdrNm = item.subOrdrNm;
                            String rmrkCnte = item.rmrkCnte;
                            String ordrCnt = item.ordrCnt;

                            bool ordrCntVisible = false;
                            if (item.ordrCnt != null) {
                              ordrCntVisible = item.ordrCnt.isNotEmpty;
                            }

                            bool rmrkVislble = false;
                            if (item.rmrkCnte != null) {
                              rmrkVislble = item.rmrkCnte.isNotEmpty;
                            }

                            String exptPrice = item.exptPrice;

                            bool exptPriceVisible = false;
                            if (item.exptPrice != null) {
                              exptPriceVisible = item.exptPrice.isNotEmpty;
                            }

                            //bool isEmpty1 = item.RmrkCnte.isNotEmpty;

                            return Slidable(
                              delegate: new SlidableDrawerDelegate(),
                              actionExtentRatio: 0.2,
                              child: new Container(
                                color: Colors.white,
                                child: new ListTile(
                                  leading: Container(
                                      child: isBuy == true
                                          ? CircleAvatar(
                                              //구매함.
                                              backgroundColor: Colors.blue,
                                              child: new Row(
                                                children: <Widget>[
                                                  new Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.white,
                                                  ),
                                                  new Text('$rowIndex')
                                                ],
                                              ),
                                              foregroundColor: Colors.white,
                                            )
                                          : new CircleAvatar(
                                              //구매안함.
                                              backgroundColor: Colors.red,
                                              child: new Text('$rowIndex'),
                                              foregroundColor: Colors.white,
                                            )),
                                  title: new Container(
                                      child: Column(
                                    children: <Widget>[
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround ,
                                        children: <Widget>[
                                          Visibility(
                                            visible: false,
                                            child: new Container(
                                                width: 100,
                                                //child: Text('[구매함]', style: TextStyle(color: Colors.red, fontSize: 12)),
                                                child: new Row(
                                                  children: <Widget>[
                                                    new Icon(
                                                      Icons.shopping_cart,
                                                      color: Colors.blue,
                                                      size: 30,
                                                    ),
                                                    new Text(
                                                      '[구매함]',
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          new Container(
                                            child: new Text('$ordrNm'),
                                          ),
                                          Visibility(
                                            visible: ordrCntVisible,
                                            child: new Container(
                                                width: 30,
                                                child: Text(
                                                  '$ordrCnt개',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 13),
                                                )),
                                          ),

                                          Spacer(), //가운데를 띄울때 사용
                                          new Container(
                                              child: Visibility(
                                                  visible: exptPriceVisible,
                                                  child: new Row(
                                                    children: <Widget>[
                                                      new Text(
                                                        '($exptPrice원)',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ],
                                                  ))),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          new Container(
                                              child: new Visibility(
                                            visible: rmrkVislble,
                                            child: new Text(
                                              '$rmrkCnte',
                                              style: new TextStyle(
                                                  color: Colors.blueGrey),
                                            ),
                                          )),
                                        ],
                                      )
                                    ],
                                  )),
                                  // subtitle: new Visibility(
                                  //   visible: '$rmrkCnte'.isNotEmpty ? true : false,
                                  //   child: new Text('$rmrkCnte'),
                                  //   //new Text('$rmrkCnte'),
                                  // )
                                ),
                              ),
                              actions: <Widget>[
                                new IconSlideAction(
                                  caption: isBuy ? '구매취소' : '구매함',
                                  color: isBuy ? Colors.red : Colors.blue,
                                  icon: Icons.local_grocery_store,
                                  onTap: () => firstBloc.ListViewClick(
                                      item, 'get', context),
                                ),
                                // new IconSlideAction(
                                //   caption: '취소',
                                //   color: Colors.indigo,
                                //   icon: Icons.cancel,
                                //   onTap: () => ListViewClick(item, 'cancel'),
                                // ),
                              ],
                              secondaryActions: <Widget>[
                                new IconSlideAction(
                                  caption: '삭제',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () => firstBloc.ListViewClick(
                                      item, 'delete', context),
                                ),
                                new IconSlideAction(
                                  caption: '수정',
                                  color: Colors.green,
                                  icon: Icons.edit,
                                  onTap: () => firstBloc.ListViewClick(
                                      item, 'edit', context),
                                ),
                              ],
                            );

                            // return Dismissible(
                            //   key: Key(item.ordrNo),
                            //     onDismissed: (direction) {
                            //       setState(() {
                            //         //orderDTO.removeAt(index);

                            //       });
                            //       Scaffold.of(context)
                            //           .showSnackBar(SnackBar(content: Text("$ordrNm dismissed")));
                            //     },
                            //     background: Container(color: Colors.red,),
                            //     child: ListTile(title: Text('$ordrNm')),
                            // );
                          }));
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {firstBloc.ItemAddPopupOpen(null, context)},
        backgroundColor: new Color(0xFFE57373),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
