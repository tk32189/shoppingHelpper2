class TitleDTO {
  String stodNo; //번호
  String ordrDirectDt; //처방지시일자
  String titlNm; //타이틀명
  String showDt; //쇼핑일자
  String ordrInfo; //쇼핑리스트 정보

  TitleDTO({this.stodNo, this.ordrDirectDt, this.titlNm, this.showDt, this.ordrInfo});
  factory TitleDTO.fromJson(Map<String, dynamic> json) {
    return TitleDTO(
      stodNo: json['STOD_NO'],
      ordrDirectDt: json['ORDR_DIRECT_DT'],
      titlNm: json['TITL_NM'],
      showDt: json["SHOW_DT"],
      ordrInfo: json["ORDR_INFO"]
     
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["STOD_NO"] = stodNo;
    map["ORDR_DIRECT_DT"] = ordrDirectDt;
    map["TITL_NM"] = titlNm ?? "";
    map["SHOW_DT"] = showDt ?? "";
    map["ORDR_INFO"] = ordrInfo ?? "";
    return map;
  }
}
