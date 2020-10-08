class UserDetails{
  int balance;
  String name;
  String mobile;
  String type;
  String address;
  UserDetails({this.balance,this.name,this.mobile,this.type,this.address});
  UserDetails. fromJson(Map<String, dynamic>json){
    this.balance = json['balance'] ?? 0;
    this.name = json['name'] ?? "";
    this.mobile = json['mobile'] ?? "";
    this.type = json['type'] ?? "";
    this.address = json['address'] ?? "";
  }
  UserDetails.withError(String errorMessage){
    this.balance = 0;
    this.name = "";
    this.address = "";
    this.mobile = "";
    this.type = "";
  }
}