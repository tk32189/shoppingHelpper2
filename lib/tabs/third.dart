import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:showpinghelper/bloc/thirdBloc.dart';
import 'package:showpinghelper/core/coreLibrary.dart';
import 'package:showpinghelper/tabs/first.dart';
import 'package:showpinghelper/datatable/titleDTO.dart';

typedef DemoItemBodyBuilder<T> = Widget Function(DemoItem<T> item);
typedef ValueToString<T> = String Function(T value);

enum Location { Barbados, Bahamas, Bermuda }

class CollapsibleBody extends StatelessWidget {
  const CollapsibleBody({
    this.margin = EdgeInsets.zero,
    this.child,
    this.onSave,
    this.onCancel,
  });

  final EdgeInsets margin;
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 24.0,
              ) -
              margin,
          child: Center(
            child: DefaultTextStyle(
              style: textTheme.caption.copyWith(fontSize: 15.0),
              child: child,
            ),
          ),
        ),
        const Divider(height: 1.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: FlatButton(
                  onPressed: onCancel,
                  child: const Text('삭제',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: FlatButton(
                  onPressed: onSave,
                  textTheme: ButtonTextTheme.accent,
                  child: const Text('재조회'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint({
    this.name,
    this.value,
    this.hint,
    this.showHint,
  });

  final String name;
  final String value;
  final String hint;
  final bool showHint;

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(left: 24.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: textTheme.body1.copyWith(fontSize: 15.0),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(left: 24.0),
            child: _crossFade(
              Text(hint, style: textTheme.caption.copyWith(fontSize: 15.0)),
              Text(hint, style: textTheme.caption.copyWith(fontSize: 15.0)),
              showHint,
            ),
          ),
        ),
      ],
    );
  }
}

class DemoItem<T> {
  DemoItem(
      {this.name,
      this.value,
      this.hint,
      this.builder,
      this.valueToString,
      this.showDt,
      this.ordrInfo,
      this.stodNo})
      : textController = TextEditingController(text: valueToString(value));

  final String name;
  final String hint;

  final String showDt; //쇼핑일자
  String ordrInfo = ""; //쇼핑정보
  String stodNo = ""; //

  String getOrdrInfo() {
    if (ordrInfo != null) {
      return ordrInfo;
    } else
      return "";
  }

  final TextEditingController textController;
  final DemoItemBodyBuilder<T> builder;
  final ValueToString<T> valueToString;
  T value;
  bool isExpanded = false;

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return DualHeaderWithHint(
        name: name,
        value: valueToString(value),
        hint: hint,
        showHint: isExpanded,
      );
    };
  }

  Widget build() => builder(this);
}

class ThirdTab extends StatefulWidget {
  ThirdTab({Key key, this.onSave, this.onResearch, this.firstTabStateKey})
      : super(key: key);

  final VoidCallback onSave;
  //GlobalKey<FirstTabState> firstTabState;
  final GlobalKey<FirstTabState> firstTabStateKey;

  //ThirdTabFul firstTabFul = new ThirdTabFul();

  //final ValueChanged<String> parentAction;
  final void Function(String value) onResearch;

  BuildContext context;

  @override
  ThirdTabState createState() => ThirdTabState();

  sendData(String message, String value) =>
      createState().onDataReceived(message, value);

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   return null;
  // }

  // Widget build(BuildContext context) {
  //   this.context = context;
  //   return new Scaffold(backgroundColor: Colors.red, body: firstTabFul);
  // }
}

// class ThirdTabFul extends StatefulWidget {
//   @override
//   ThirdTabState createState() => new ThirdTabState();
// }

ThrdBloc thrdBloc = new ThrdBloc();

class ThirdTabState extends State<ThirdTab> {
  List<DemoItem<dynamic>> _demoItems;
  bool isNeedToSelect = false;

  //다른화면에서 전달되는 데이터 처리
  void onDataReceived(String message, String value) {
    if (message == "SelectTitleData") {
      SelectTitleList();
    }
  }

  //타이틀 리스트를 재조회한다.
  void SelectTitleList()
  {
    thrdBloc.SelectTitleList(CoreLibrary.userId);
  }


  @override
  void initState() {
    super.initState();

    if (thrdBloc != null) {
      thrdBloc.buildContext = context;

      // () async {
      //   await Future.delayed(Duration.zero);
      //   thrdBloc.SelectTitleList(CoreLibrary.userId);
      // }();

      //thrdBloc.SelectTitleList(CoreLibrary.userId);

      this.isNeedToSelect = true;
    }

    // List<TitleDTO> titleList = thrdBloc.titleList;

    // this._demoItems = <DemoItem<dynamic>>[];

    // if (titleList != null && titleList.length > 0) {
    //   for (int i = 0; i < titleList.length; i++) {
    //     DemoItem item = TitleControlInit(titleList[i]);
    //     this._demoItems.add(item);
    //   }
    // }

    // _demoItems = <DemoItem<dynamic>>[
    //   DemoItem<String>(
    //     name: 'Trip',
    //     value: 'Caribbean cruise',
    //     hint: 'Change trip name',
    //     valueToString: (String value) => value,
    //     builder: (DemoItem<String> item) {
    //       void close() {
    //         setState(() {
    //           item.isExpanded = false;
    //         });
    //       }

    //       return Form(
    //         child: Builder(
    //           builder: (BuildContext context) {
    //             return CollapsibleBody(
    //               margin: const EdgeInsets.symmetric(horizontal: 16.0),
    //               onSave: () {
    //                 Form.of(context).save();
    //                 close();
    //               },
    //               onCancel: () {
    //                 Form.of(context).reset();
    //                 close();
    //               },
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //                 child: TextFormField(
    //                   controller: item.textController,
    //                   decoration: InputDecoration(
    //                     hintText: item.hint,
    //                     labelText: item.name,
    //                   ),
    //                   onSaved: (String value) {
    //                     item.value = value;
    //                   },
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       );
    //     },
    //   ),
    //   DemoItem<Location>(
    //     name: 'Location',
    //     value: Location.Bahamas,
    //     hint: 'Select location',
    //     valueToString: (Location location) => location.toString().split('.')[1],
    //     builder: (DemoItem<Location> item) {
    //       void close() {
    //         setState(() {
    //           item.isExpanded = false;
    //         });
    //       }

    //       return Form(
    //         child: Builder(builder: (BuildContext context) {
    //           return CollapsibleBody(
    //             onSave: () {
    //               Form.of(context).save();
    //               close();
    //             },
    //             onCancel: () {
    //               Form.of(context).reset();
    //               close();
    //             },
    //             child: FormField<Location>(
    //               initialValue: item.value,
    //               onSaved: (Location result) {
    //                 item.value = result;
    //               },
    //               builder: (FormFieldState<Location> field) {
    //                 return Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     RadioListTile<Location>(
    //                       value: Location.Bahamas,
    //                       title: const Text('Bahamas'),
    //                       groupValue: field.value,
    //                       onChanged: field.didChange,
    //                     ),
    //                     RadioListTile<Location>(
    //                       value: Location.Barbados,
    //                       title: const Text('Barbados'),
    //                       groupValue: field.value,
    //                       onChanged: field.didChange,
    //                     ),
    //                     RadioListTile<Location>(
    //                       value: Location.Bermuda,
    //                       title: const Text('Bermuda'),
    //                       groupValue: field.value,
    //                       onChanged: field.didChange,
    //                     ),
    //                   ],
    //                 );
    //               },
    //             ),
    //           );
    //         }),
    //       );
    //     },
    //   ),
    //   DemoItem<double>(
    //     name: 'Sun',
    //     value: 80.0,
    //     hint: 'Select sun level',
    //     valueToString: (double amount) => '${amount.round()}',
    //     builder: (DemoItem<double> item) {
    //       void close() {
    //         setState(() {
    //           item.isExpanded = false;
    //         });
    //       }

    //       return Form(
    //         child: Builder(builder: (BuildContext context) {
    //           return CollapsibleBody(
    //             onSave: () {
    //               Form.of(context).save();
    //               close();
    //             },
    //             onCancel: () {
    //               Form.of(context).reset();
    //               close();
    //             },
    //             child: FormField<double>(
    //               initialValue: item.value,
    //               onSaved: (double value) {
    //                 item.value = value;
    //               },
    //               builder: (FormFieldState<double> field) {
    //                 return Container(
    //                   // Allow room for the value indicator.
    //                   padding: const EdgeInsets.only(top: 44.0),
    //                   child: Slider(
    //                     min: 0.0,
    //                     max: 100.0,
    //                     divisions: 5,
    //                     activeColor:
    //                         Colors.orange[100 + (field.value * 5.0).round()],
    //                     label: '${field.value.round()}',
    //                     value: field.value,
    //                     onChanged: field.didChange,
    //                   ),
    //                 );
    //               },
    //             ),
    //           );
    //         }),
    //       );
    //     },
    //   ),
    // ];
  }

  //타이틀 정보를 설정한다.
  DemoItem<String> TitleControlInit(TitleDTO title) {
    return DemoItem<String>(
      name: title.ordrDirectDt,
      value: title.stodNo,
      hint: title.titlNm,
      showDt: title.showDt,
      ordrInfo: title.ordrInfo,
      stodNo: title.stodNo,
      valueToString: (String value) => value,
      builder: (DemoItem<String> item) {
        void close() {
          setState(() {
            item.isExpanded = false;
          });
        }

        return Form(
          child: Builder(
            builder: (BuildContext context) {
              return CollapsibleBody(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                onSave: () {
                  Form.of(context).save();
                  widget.onResearch(item.stodNo);
                  close();
                },
                onCancel: () {
                  Form.of(context).reset();
                  //ShowMessageBox(context, "확인", "정말 삭제하시겠습니까?");
                  String titlNm = title.titlNm;
                  ShowMessageBoxWithConfirm(
                          context, "삭제", "[$titlNm]\r\n\r\n정말 삭제하시겠습니까?")
                      .then((ConfirmAction onValue) {
                    if (onValue == ConfirmAction.ACCEPT) {
                      //타이틀 삭제
                      thrdBloc.DeleteTitle(CoreLibrary.userId, title.stodNo);
                    } else if (onValue == ConfirmAction.CANCEL) {
                      //PASS
                    }
                  });

                  close();
                },
                //455
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text('쇼핑일 : ' + StringToDisplayDate(item.showDt)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        item.getOrdrInfo(),
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: TextFormField(
                      //     //controller: item.textController,
                      //     // decoration: InputDecoration(
                      //     //   hintText: item.hint,
                      //     //   labelText: item.name,
                      //     // ),
                      //     onSaved: (String value) {
                      //       item.value = value;
                      //       //widget.onResearch(item.stodNo);
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                  // child: Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: TextFormField(
                  //     controller: item.textController,
                  //     decoration: InputDecoration(
                  //       hintText: item.hint,
                  //       labelText: item.name,
                  //     ),
                  //     onSaved: (String value) {
                  //       item.value = value;
                  //       widget.onResearch(value);
                  //     },
                  //   ),
                  // ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    // return StreamBuilder(
    //     stream: thrdBloc.getTitleList,
    //     builder: (BuildContext context, AsyncSnapshot<List<TitleDTO>> snapshot) {
    //       return snapshot.hasData ? Text(snapshot.data.toString()) : Text('nodata');
    //     });

    return StreamBuilder(
        stream: thrdBloc.getTitleList,
        builder: (context, snapshot) {
          if (snapshot.hasData && isNeedToSelect == true) {
            List<TitleDTO> titleList = thrdBloc.titleList;

            this._demoItems = <DemoItem<dynamic>>[];

            if (titleList != null && titleList.length > 0) {
              for (int i = 0; i < titleList.length; i++) {
                DemoItem item = TitleControlInit(titleList[i]);
                this._demoItems.add(item);
              }
            }
            isNeedToSelect = false;
          }
          return snapshot.hasData
              ? Scaffold(
                  body: SingleChildScrollView(
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: Container(
                        margin: const EdgeInsets.all(24.0),
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _demoItems[index].isExpanded = !isExpanded;
                            });
                          },
                          children: _demoItems
                              .map<ExpansionPanel>((DemoItem<dynamic> item) {
                            return ExpansionPanel(
                              isExpanded: item.isExpanded,
                              headerBuilder: item.headerBuilder,
                              body: item.build(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : new Container(
                height: 50,
                width: 50,
                child: new CircularProgressIndicator(),
              ); 
        });
  }
}
