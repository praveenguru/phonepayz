class GetDthServiceProviders{
  List<DthServiceProviders> providers;
  GetDthServiceProviders({this.providers});
  GetDthServiceProviders.fromJson(List<dynamic>list){
    this.providers = list.map((i) => DthServiceProviders.fromJson(i)).toList();
  }
  GetDthServiceProviders.withError(String errorMessage){
    this.providers = [];
  }
}

class DthServiceProviders{
  int id;
  String name;
  String api;
  String image;
  String code;
  DthServiceProviders({this.name,this.id,this.api,this.image,this.code});
  DthServiceProviders.fromJson(Map<String, dynamic>json){
    this.id = json["id"] ?? 0;
    this.name = json["name"] ?? "";
    this.api = json["api"] ?? "";
    this.image = json["image"] ?? "";
    this.code = json["mplan_code"] ?? "";
  }
  DthServiceProviders.withError(String errorMessage){
    this.id = 0;
    this.name = "";
    this.api = "";
    this.image = "";
    this.code = "";
  }
}