class GetRetailersResponse{
  bool status;
  String message;
  List<Retailers>retailers;
  GetRetailersResponse({this.status,this.message,this.retailers});
  GetRetailersResponse.fromJson(Map<String, dynamic>json){
    this.status = json['status'];
    this.message = json['message'];
    this.retailers = json['data'].map<Retailers>((i) => Retailers.fromJson(i)).toList();
  }
  GetRetailersResponse.withError(String errorMessage){
    this.status = false;
    this.message = errorMessage;
    this.retailers = [];
  }
}

class Retailers{
  String name;
  String mobile;
  String address;
  int balance;
  bool isactive;
  String id;
  Retailers({this.name,this.mobile,this.balance,this.isactive,this.address,this.id});
  Retailers.fromJson(Map<String, dynamic>json){
    this.name = json['name'] ?? "";
    this.mobile = json['mobile'] ?? "";
    this.address = json['address'] ?? "";
    this.id = json['_id'] ?? "";
    this.balance = json['balance'] ?? 0;
    this.isactive = json['is_active'] ?? false;
  }
}