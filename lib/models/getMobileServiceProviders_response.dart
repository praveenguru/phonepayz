class GetMobileServiceProviders{
  List<MobileServiceProviders> providers;
  GetMobileServiceProviders({this.providers});
  GetMobileServiceProviders.fromJson(List<dynamic>list){
    this.providers = list.map((i) => MobileServiceProviders.fromJson(i)).toList();
  }
  GetMobileServiceProviders.withError(String errorMessage){
    this.providers = [];
  }
}

class MobileServiceProviders{
  int id;
  String name;
  String api;
  String image;
  String code;
  MobileServiceProviders({this.name,this.id,this.api,this.image,this.code});
  MobileServiceProviders.fromJson(Map<String, dynamic>json){
    this.id = json["id"] ?? 0;
    this.name = json["name"] ?? "";
    this.image = json["image"] ?? "";
    this.api = json["api"] ?? "";
    this.code = json["mplan_code"] ?? "";
  }
  MobileServiceProviders.withError(String errorMessage){
    this.id = 0;
    this.name = "";
    this.api = "";
    this.image = "";
    this.code = "";
  }
}