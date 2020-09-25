class GetMobileOperatorsResponse{
  bool status;
  String message;
  List<MobileOperators>operators;
  GetMobileOperatorsResponse({this.status,this.message,this.operators});
  GetMobileOperatorsResponse.fromJson(List<dynamic>list){
    this.operators =  list.map((i) => MobileOperators.fromJson(i)).toList();
  }
  GetMobileOperatorsResponse.withError(String errorMessage){
    this.status = false;
    this.message = errorMessage;
    this.operators = [];
  }
}

class MobileOperators{
  String name;
  String image;
  String code;
  MobileOperators({this.name,this.image,this.code});
  MobileOperators.fromJson(Map<String, dynamic>json){
    this.name = json['name'] ?? "";
    this.image = json['image'] ?? "";
    this.code = json['code'] ?? "";
  }
}