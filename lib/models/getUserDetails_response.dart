class GetUserDetailsResponse{
  bool status;
  String message;
  UserDetails data;
  GetUserDetailsResponse({this.status,this.message,this.data});

  GetUserDetailsResponse.fromJson(Map<String, dynamic>json){
    this.status = json['status'];
    this.message = json['message'];
    this.data = UserDetails.fromJson(json['data']);
  }

  GetUserDetailsResponse.withError(String errorMessage){
    this.status = false;
    this.message = errorMessage;
    this.data = UserDetails(balance: 0,name: "",mobile: "",type: "",address: "");
  }
}

class UserDetails{
  int balance;
  String name;
  String mobile;
  String type;
  String address;
  UserDetails({this.balance,this.name,this.mobile,this.type,this.address});
  UserDetails.fromJson(Map<String, dynamic>json){
    this.balance = json['balance'] ?? 0;
    this.name = json['name'] ?? "";
    this.mobile = json['mobile'] ?? "";
    this.type = json['type'] ?? "";
    this.address = json['address'] ?? "";
  }
}