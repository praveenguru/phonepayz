class GetTransactionsResponse{
  bool status;
  String message;
  List<Transaction> data;
  GetTransactionsResponse({this.status,this.message,this.data});

  GetTransactionsResponse.fromJson(Map<String, dynamic>json){
    this.status = json['status'] ?? false;
    this.message = json['message'] ?? "";
    this.data = json['data'].map<Transaction>((i) => Transaction.fromJson(i)).toList();
  }

  GetTransactionsResponse.withError(String errorMessage){
    this.status = false;
    this.message = errorMessage;
    this.data = [];
  }
}

class Transaction{
  int amount;
  String mobile;
  String type;
  String status;
  String image;
  String operator;
  Transaction({this.amount,this.mobile,this.type,this.status,this.operator,this.image});
  Transaction.fromJson(Map<String, dynamic>json){
    this.amount = json['amount'] ?? 0;
    this.mobile = json['number'] ?? "";
    this.type = json['type'] ?? "";
    this.status = json['status'] ?? "";
    this.image = json['image'] ?? "";
    this.operator = json['operator'] ?? "";
  }
}


class GetAdminTransactions{
  bool status;
  String message;
  List<AdminTransaction> data;
  GetAdminTransactions({this.status,this.message,this.data});

  GetAdminTransactions.fromJson(Map<String, dynamic>json){
    this.status = json['status'] ?? false;
    this.message = json['message'] ?? "";
    this.data = json['data'].map<AdminTransaction>((i) => AdminTransaction.fromJson(i)).toList();
  }

  GetAdminTransactions.withError(String errorMessage){
    this.status = false;
    this.message = errorMessage;
    this.data = [];
  }
}

class AdminTransaction{
  int amount;
  String mobile;
  String type;
  String status;
  String image;
  String operator;
  TransactionUser user;
  AdminTransaction({this.amount,this.mobile,this.type,this.status,this.operator,this.image,this.user});
  AdminTransaction.fromJson(Map<String, dynamic>json){
    this.amount = json['amount'] ?? 0;
    this.mobile = json['number'] ?? "";
    this.type = json['type'] ?? "";
    this.status = json['status'] ?? "";
    this.user = TransactionUser.fromJson(json['user']);
    this.image = json['image'] ?? "";
    this.operator = json['operator'] ?? "";
  }
}


class TransactionUser{
  String name;
  int balance;
  String type;
  String address;
  String mobile;
  TransactionUser({this.name,this.balance,this.type,this.address,this.mobile,});
  TransactionUser.fromJson(Map<String, dynamic>json){
    this.balance = json['balance'] ?? 0;
    this.mobile = json['mobile'] ?? "";
    this.type = json['type'] ?? "";
    this.address = json['address'] ?? "";
    this.mobile = json['mobile'] ?? "";
    this.name = json['name'] ?? "";
  }
}