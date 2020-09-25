class GetDistributorsResponse{
  bool status;
  String message;
  List<Distributors>distributors;
  GetDistributorsResponse({this.status,this.message,this.distributors});
  GetDistributorsResponse.fromJson(Map<String, dynamic>json){
    this.status = json['status'];
    this.message = json['message'];
    this.distributors = json['data'].map<Distributors>((i) => Distributors.fromJson(i)).toList();
  }
  GetDistributorsResponse.withError(String errorMessage){
    this.status = false;
    this.message = errorMessage;
    this.distributors = [];
  }
}

class Distributors{
  String name;
  String mobile;
  String address;
  int balance;
  bool isactive;
  String id;
  Distributors({this.name,this.mobile,this.balance,this.isactive,this.address,this.id});
  Distributors.fromJson(Map<String, dynamic>json){
    this.name = json['name'] ?? "";
    this.mobile = json['mobile'] ?? "";
    this.address = json['address'] ?? "";
    this.id = json['_id'] ?? "";
    this.balance = json['balance'] ?? 0;
    this.isactive = json['is_active'] ?? false;
  }
}