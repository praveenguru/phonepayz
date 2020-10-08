class GetTransactionsResponse{
  List<Transaction> data;
  GetTransactionsResponse({this.data});

  GetTransactionsResponse.fromJson(List<dynamic>list){
    this.data = list.map<Transaction>((i) => Transaction.fromJson(i)).toList();
  }

  GetTransactionsResponse.withError(String errorMessage){
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
  String api_provider;
  MobileServiceProvider provider;
  TransactionUser user;
  Transaction({this.amount,this.mobile,this.type,this.status,this.operator,this.image,this.provider,this.api_provider,this.user});
  Transaction.fromJson(Map<String, dynamic>json){
    this.amount = json['amount'] ?? 0;
    this.mobile = json['number'] ?? "";
    this.type = json['type'] ?? "";
    this.status = json['status'] ?? "";
    this.image = json['image'] ?? "";
    this.operator = json['operator'] ?? "";
    this.api_provider = json['api_provider'] ?? "";
    this.provider = MobileServiceProvider.fromJson(json['service_provider']);
    this.user = TransactionUser.fromJson(json['user']);
  }
}

class MobileServiceProvider{
  String name;
  String image;
  MobileServiceProvider({this.name,this.image});
  MobileServiceProvider.fromJson(Map<String, dynamic>json){
    this.name = json['name'] ?? "";
    this.image = json['image'] ?? "";
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

class GetMobileTransactionResponse{
  List<MobileTransaction> data;
  GetMobileTransactionResponse({this.data});

  GetMobileTransactionResponse.fromJson(List<dynamic>list){
    this.data = list.map<MobileTransaction>((i) => MobileTransaction.fromJson(i)).toList();
  }

  GetMobileTransactionResponse.withError(String errorMessage){
    this.data = [];
  }
}

class MobileTransaction{
  int amount;
  String mobile;
  String type;
  String status;
  String image;
  String operator;
  MobileTransaction({this.amount,this.mobile,this.type,this.status,this.operator,this.image});
  MobileTransaction.fromJson(Map<String, dynamic>json){
    this.amount = json['amount'] ?? 0;
    this.mobile = json['number'] ?? "";
    this.type = json['type'] ?? "";
    this.status = json['status'] ?? "";
    this.image = json['image'] ?? "";
    this.operator = json['operator'] ?? "";
  }
}


