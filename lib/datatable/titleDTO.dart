class TitleDTO {
  String stodNo; //번호
  String ordrDirectDt; //처방지시일자
  String titlNm; //타이틀명

  TitleDTO({this.stodNo, this.ordrDirectDt, this.titlNm});
  factory TitleDTO.fromJson(Map<String, dynamic> json) {
    return TitleDTO(
      stodNo: json['STOD_NO'],
      ordrDirectDt: json['ORDR_DIRECT_DT'],
      titlNm: json['TITL_NM'],
     
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["STOD_NO"] = stodNo;
    map["ORDR_DIRECT_DT"] = ordrDirectDt;
    map["TITL_NM"] = titlNm ?? "";
    return map;
  }
}
