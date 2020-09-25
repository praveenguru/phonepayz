class GetDthOperatorsResponse{
  bool status;
  String message;
  List<DthOperators>operators;
  GetDthOperatorsResponse({this.status,this.message,this.operators});
  GetDthOperatorsResponse.fromJson(List<dynamic>list){
    this.operators =  list.map((i) => DthOperators.fromJson(i)).toList();
  }
  GetDthOperatorsResponse.withError(String errorMessage){
    this.status = false;
    this.message = errorMessage;
    this.operators = [];
  }
}

class DthOperators{
  String name;
  String image;
  String code;
  DthOperators({this.name,this.image,this.code});
  DthOperators.fromJson(Map<String, dynamic>json){
    this.name = json['name'] ?? "";
    this.image = json['image'] ?? "";
    this.code = json['code'] ?? "";
  }
}