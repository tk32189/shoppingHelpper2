import 'package:flutter/material.dart';
import 'package:showpinghelper/core/coreLibrary.dart';
import 'package:showpinghelper/tabs/first.dart';
import 'package:showpinghelper/tabs/second.dart';
import 'package:showpinghelper/tabs/third.dart';
import 'package:showpinghelper/tabs/userInfo.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: titleName),
    );
  }

  String titleName = "쇼핑리스트";

  void ChangeTitle(String inTitleName) {
    titleName = inTitleName;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  TabController controller;

  GlobalKey<FirstTabState> globalKey;

  final GlobalKey<FirstTabState> animatedStateKey = GlobalKey<FirstTabState>();
  final fooState = GlobalKey<FirstTabState>();

  //GlobalKey<FirstTabState> _keyChild1 = GlobalKey();

  final _keyChild2 = GlobalKey<FirstTabState>();

  String titleNmae = "쇼핑리스트";

  //탭 선택 변경시 이벤트 처리
  void _setActiveTabIndex() {
    setState(() {
      if (controller.index == 0) {
        //widget.ChangeTitle("")
        titleNmae = "쇼핑리스트";
      } else if (controller.index == 1) {
        titleNmae = "히스토리";
        thirdTab.sendData("SelectTitleData", "");
      } else if (controller.index == 2) {
        titleNmae = "내정보";
      }
    });
  }

  //히스토리에서 재조회 버튼 클릭시
  ResearchButtonClick(String value) {
    print(value);
    controller.index = 0;
    //_keyChild1.currentState.onDataReceived("updateTitleInfo", value);

    //fooState.currentState.onDataReceivedsingle("11111");

    firstTab.sendData("updateTitleInfo", value);
  }

  @override
  void initState() {
    super.initState();


    CoreLibrary core = new CoreLibrary();
          core.AuthRead().then((value){
            String result = value.toString();
            if ( result != null && result.length > 0){
              CoreLibrary.userId = result;

              firstTab.sendData("SelectUserInfo", "");
            }
          });


    controller = new TabController(length: 3, vsync: this);
    controller.addListener(_setActiveTabIndex);

    FirstTab(key: animatedStateKey);

    

    //사용자 정보 확인
     

    //this.globalKey = new GlobalKey();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  FirstTab firstTab;
  ThirdTab thirdTab;

// FirstTab firstTab = new FirstTab(
//     );

  @override
  Widget build(BuildContext context) {
    firstTab = new FirstTab();
    SecondTab secondTab = new SecondTab();
    thirdTab = new ThirdTab(
      onResearch: ResearchButtonClick,
      firstTabStateKey: animatedStateKey,
    );

    UserInfoTab userInfoTab = new UserInfoTab();
    
    
    return Scaffold(
      appBar: AppBar(
        title: Text(titleNmae),
        backgroundColor: new Color(0xFFE57373),
      ),
      body: new TabBarView(
        children: <Widget>[firstTab, thirdTab, userInfoTab ],
        controller: controller,
      ),
      bottomNavigationBar: new Material(
        color: new Color(0xFFE57373),
        child: new TabBar(
          tabs: <Widget>[
            new Tab(
                icon: new Row(
              children: <Widget>[
                new Icon(Icons.shopping_cart),
                new SizedBox(
                  width: 10,
                ),
                new Text("쇼핑리스트")
              ],
            )),
            // new Tab(
            //     icon: new Row(
            //   children: <Widget>[
            //     new Icon(Icons.home),
            //     new SizedBox(
            //       width: 10,
            //     ),
            //     new Text("아직미정")
            //   ],
            // )),
            new Tab(
                icon: new Row(
              children: <Widget>[
                new Icon(Icons.history),
                new SizedBox(
                  width: 10,
                ),
                new Text("히스토리")
              ],
            )),
            new Tab(
                icon: new Row(
              children: <Widget>[
                new Icon(Icons.store_mall_directory),
                new SizedBox(
                  width: 10,
                ),
                new Text("내정보")
              ],
            ))
          ],
          controller: controller,
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: FloatingButtonClicked,
      //   backgroundColor: new Color(0xFFE57373),
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation
      //     .endFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
