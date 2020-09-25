class GetPlansResponse{
  bool status;
  String message;
  List<Plans>plans;
  GetPlansResponse({this.status,this.message,this.plans});
  GetPlansResponse.fromJson(List<dynamic>list){
    this.plans =  list.map((i) => Plans.fromJson(i)).toList();
  }
  GetPlansResponse.withError(String errorMessage){
    this.status = false;
    this.message = errorMessage;
    this.plans = [];
  }
}

class Plans{
  String rs;
  String desc;
  Plans({this.rs,this.desc});
  Plans.fromJson(Map<String, dynamic>json){
    this.rs = json['rs'] ?? "";
    this.desc = json['desc'] ?? "";
  }
}