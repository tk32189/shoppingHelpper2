import 'package:showpinghelper/popup/itemAdd.dart';

class OrderDTO {
  String ordrNo; //처방번호
  String ordrNm; //처방명
  String patNo = ""; //환자번호
  String ordrDirectDt; //처방지시일
  String vistSn; //내원번호
  String rmrkCnte; //기타
  String exptPrice; //예상가격

  String ordrCd; //처방코드
  String subOrdrNm; //서브처방명
  String buyYn = ""; //구매여부
  //bool isBuy = false;
  String rowIndex;
  String ordrCnt; //건수

  OrderDTO(
      {this.ordrNo,
      this.ordrNm,
      this.patNo,
      this.ordrDirectDt,
      this.vistSn,
      this.rmrkCnte,
      this.exptPrice,
      this.buyYn,
      this.ordrCnt
      });

  factory OrderDTO.fromJson(Map<String, dynamic> json) {
    return OrderDTO(
      ordrNo: json['ORDR_NO'],
      ordrNm: json['ORDR_NM'],
      patNo: json['PATNO'],
      ordrDirectDt: json['ORDR_DIRECT_DT'],
      vistSn: json['VIST_SN'],
      rmrkCnte: json['RMRK_CNTE'],
      exptPrice: json['EXPT_PRICE'],
      buyYn: json['BUY_YN'],
      ordrCnt: json['ORDR_CNT'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ORDR_NO"] = ordrNo;
    map["ORDR_NM"] = ordrNm;
    map["PATNO"] = patNo ?? "";
    map["ORDR_DIRECT_DT"] = ordrDirectDt ?? "";
    map["VIST_SN"] = vistSn ?? "";
    map["RMRK_CNTE"] = rmrkCnte ?? "";
    map["EXPT_PRICE"] = exptPrice ?? "";
    map["BUY_YN"] = buyYn ?? "";
    map["ORDR_CNT"] = ordrCnt ?? "";
    return map;
  }

  void GetOrdrNm() {
    StringBuffer str = new StringBuffer();
    if (this.buyYn == "Y") {
      str.write("[구매함]");
    }

    str.write(this.ordrNm);
  }
}
