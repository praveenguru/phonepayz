class GetSuperDistributorsResponse{
  bool status;
  String message;
  List<SuperDistributors>superDistributors;
  GetSuperDistributorsResponse({this.status,this.message,this.superDistributors});
  GetSuperDistributorsResponse.fromJson(Map<String, dynamic>json){
    this.status = json['status'];
    this.message = json['message'];
    this.superDistributors = json['data'].map<SuperDistributors>((i) => SuperDistributors.fromJson(i)).toList();
  }
  GetSuperDistributorsResponse.withError(String errorMessage){
    this.status = false;
    this.message = errorMessage;
    this.superDistributors = [];
  }
}

class SuperDistributors{
  String name;
  String mobile;
  String address;
  int balance;
  bool isactive;
  String id;
  SuperDistributors({this.name,this.mobile,this.balance,this.isactive,this.address,this.id});
  SuperDistributors.fromJson(Map<String, dynamic>json){
    this.name = json['name'] ?? "";
    this.mobile = json['mobile'] ?? "";
    this.address = json['address'] ?? "";
    this.id = json['_id'] ?? "";
    this.balance = json['balance'] ?? 0;
    this.isactive = json['is_active'] ?? false;
  }
}