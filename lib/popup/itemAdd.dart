import 'package:flutter/gestures.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:showpinghelper/datatable/orderDTO.dart';
import 'package:showpinghelper/datatable/resultDataDTO.dart';


  String _validateName(String value) {
    //_formWasEdited = true;
    // if (value.isEmpty)
    //   return 'Name is required.';
    // final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    // if (!nameExp.hasMatch(value))
    //   return 'Please enter only alphabetical characters.';
    return null;
  }

bool _autovalidate = false;
String ordrName = ""; //처방명
String rmrkCnte = ""; //기타
String email = "";
String exptPrice = "";
OrderDTO order ;
String ordrNo = "";
ResultData resultData = new ResultData();
String buttonText = "";
String ordrcnt = "";


Widget ItemAddPopup(BuildContext context, ResultData inputData){
  Key txtOrdrName;
  
    //초기화
    ordrName = "";
    rmrkCnte = "";
    email = "";
    order = null;
    exptPrice = "";
    ordrNo = "";
    buttonText = "등록";
    ordrcnt = "1";
    
    resultData = new ResultData();

    //수정모드로 들어온 경우
    if (inputData != null)
    {
        if ( inputData.resultObject != null && inputData.resultObject is OrderDTO)
        {
          OrderDTO order = inputData.resultObject as OrderDTO;
          ordrName =  order.ordrNm;
          rmrkCnte = order.rmrkCnte;
          exptPrice = order.exptPrice;
          ordrNo = order.ordrNo;
          ordrcnt = order.ordrCnt;

          buttonText = "수정";
          
        }


    }



    return SafeArea(
        top: false,
        bottom: false,
        child: Form(
         // key: _formKey,
          autovalidate: _autovalidate,
          //onWillPop: _warnUserAboutInvalidData,
          child: Scrollbar(
            child: SingleChildScrollView(
              dragStartBehavior: prefix0.DragStartBehavior.down,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 24.0),
                  TextFormField(
                    key: txtOrdrName,
                    initialValue: ordrName,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.add_shopping_cart),
                      hintText: '추가할 상품을 입력하세요',
                      labelText: '이름 *',
                    ),
                    
                    onChanged: (String value) { 
                      
                      ordrName = value; 
                      },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: ordrcnt,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '개수',
                      //prefixText: '\$',
                      suffixText: '개',
                      suffixStyle: TextStyle(color: Colors.green),
                    ),
                    onChanged: (String value) { 
                      
                    ordrcnt = value; 
                      },
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: rmrkCnte,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '그 외 필요한 내용이 있으면 적어주세요',
                      //helperText: 'Keep it short, this is just a demo.',
                      labelText: '기타',
                    ),
                    onChanged: (String value) { 
                      
                      rmrkCnte = value; 
                      },
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    initialValue: exptPrice,
                    keyboardType: TextInputType.number,
                    //inputFormatters: [ BlacklistingTextInputFormatter()  ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '예상가격',
                      //prefixText: '\$',
                      suffixText: '원',
                      suffixStyle: TextStyle(color: Colors.green),
                    ),
                    onChanged: (String value) { 
                      
                      exptPrice = value; 
                      },
                    maxLines: 1,
                  ),
                  const SizedBox(height: 24.0),
                  RaisedButton(
                    color: Colors.green[200],
                    child: Text(buttonText),
                    onPressed: (){
                    String test = "메시지";
                      order = new OrderDTO();
                        order.ordrNo = "";
                        order.ordrNm = ordrName;
                        order.ordrCd = "";
                        order.ordrDirectDt = "";
                        order.vistSn = "";
                        order.subOrdrNm = " ";
                        order.rmrkCnte = rmrkCnte;
                        
                        order.exptPrice = exptPrice;
                        order.ordrCnt = ordrcnt;
                        order.ordrNo = ordrNo;

                  resultData.resultState = ResultState.yes;
                  resultData.resultObject = order;
                    Navigator.pop<ResultData>(context, resultData); //close the popup
                  },)
                ],
              ),
            ),
          ),
        ),
      );
  }