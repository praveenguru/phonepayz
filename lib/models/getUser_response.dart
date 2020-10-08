class GetUserResponse{
  List<UserData> userData = [];
  GetUserResponse.fromJson(List<dynamic>list){
    this.userData = list.map((i) => UserData.fromJson(i)).toList();
  }
  GetUserResponse.withError(String errorMessage){
    this.userData = [];
  }
}

class UserData{
  int balance;
  bool isActive;
  int id;
  String name;
  String address;
  String mobile;
  String type;
  UserData({this.name,this.isActive,this.id,this.balance,this.address,this.mobile,this.type});
  UserData.fromJson(Map<String, dynamic>json){
    this.isActive = json["is_active"] ?? false;
    this.id = json["id"] ?? 0;
    this.balance = json["balance"] ?? 0;
    this.name = json["name"] ?? "";
    this.address = json["address"] ?? "";
    this.mobile = json["mobile"] ?? "";
    this.type = json["type"] ?? "";
  }
  UserData.withError(String errorMessage){
    this.isActive = false;
    this.id = 0;
    this.balance = 0;
    this.name = "";
    this.address = "";
    this.mobile = "";
    this.type = "";
  }
}

class Parent{
  int balance;
  bool isActive;
  String id;
  String name;
  String address;
  String mobile;
  String type;
  Parent({this.name,this.isActive,this.id,this.balance,this.type,this.address,this.mobile});
  Parent.fromJson(Map<String, dynamic>json){
    this.isActive = json["is_active"] ?? false;
    this.id = json["_id"] ?? 0;
    this.balance = json["balance"] ?? 0;
    this.name = json["name"] ?? "";
    this.address = json["address"] ?? "";
    this.mobile = json["mobile"] ?? "";
    this.type = json["type"] ?? "";
  }
}