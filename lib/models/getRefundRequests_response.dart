import 'package:phonepayz/models/getTransaction_response.dart';
import 'package:phonepayz/modules/adminTransactions/adminTransactions.dart';

class GetRefundRequestsResponse{
  List<RefundRequest> refund = [];
  GetRefundRequestsResponse.fromJson(List<dynamic>list){
    this.refund = list.map((i) => RefundRequest.fromJson(i)).toList();
  }
  GetRefundRequestsResponse.withError(String errorMessage){
    this.refund = [];
  }
}

class RefundRequest{
  String type;
  String name;
  String status;
  int id;
  String mobile;
  RefundTransaction transaction;
  RefundRequest({this.type,this.mobile,this.name,this.status,this.transaction,this.id});
  RefundRequest.fromJson(Map<String, dynamic>json){
    this.type = json["type"] ?? "";
    this.name = json["name"] ?? "";
    this.id = json["id"] ?? 0;
    this.status = json["status"] ?? "";
    this.mobile = json["mobile"] ?? "";
    this.transaction = RefundTransaction.fromJson(json['transaction']);
  }
  RefundRequest.withError(String errorMessage){
    this.type = "";
    this.status = "";
    this.name = "";
    this.mobile = "";
    this.id = 0;
  }
}

class RefundTransaction {
  int amount;
  String mobile;
  String type;
  String status;
  String api_provider;
  RefundUser user;
  MobileServiceProvider provider;
  RefundTransaction(
      {this.amount, this.mobile, this.type, this.status, this.user,this.api_provider});

  RefundTransaction.fromJson(Map<String, dynamic>json){
    this.amount = json['amount'] ?? 0;
    this.mobile = json['number'] ?? "";
    this.type = json['type'] ?? "";
    this.status = json['status'] ?? "";
    this.api_provider = json['api_provider'] ?? "";
    this.user = RefundUser.fromJson(json['user']);
    this.provider = MobileServiceProvider.fromJson(json['service_provider']);
  }
}

class RefundUser{
  String type;
  String name;
  String address;
  String mobile;
  RefundUser({this.type,this.mobile,this.name,this.address});
  RefundUser.fromJson(Map<String, dynamic>json){
    this.type = json["type"] ?? "";
    this.name = json["name"] ?? "";
    this.address = json["address"] ?? "";
    this.mobile = json["mobile"] ?? "";
  }
}