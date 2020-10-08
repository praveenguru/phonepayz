class Dashboard{
  int super_distributors_count;
  int distributors_count;
  int retailers_count;
  int outstanding_balance;
  int users_count;
  List<OutstandingBalanceDetail> outstanding_balance_detail;
  Dashboard({this.super_distributors_count,this.distributors_count,this.retailers_count,this.outstanding_balance_detail,this.outstanding_balance,this.users_count});
  Dashboard.fromJson(Map<String, dynamic>json){
    this.super_distributors_count = json['super_distributors_count'] ?? 0;
    this.distributors_count = json['distributors_count'] ?? 0;
    this.retailers_count = json['retailers_count'] ?? 0;
    this.outstanding_balance = json['outstanding_balance'] ?? 0;
    this.users_count = json['users_count'] ?? 0;
    this.outstanding_balance_detail = json['outstanding_balance_detail'].map<OutstandingBalanceDetail>((i) => OutstandingBalanceDetail.fromJson(i)).toList();
  }
  Dashboard.withError(String errorMessage){
    this.super_distributors_count = 0;
    this.distributors_count = 0;
    this.retailers_count = 0;
    this.outstanding_balance_detail = [];
  }

}

class OutstandingBalanceDetail{
  int id;
  int balance;
  OutstandingBalanceDetail({this.id,this.balance});
  OutstandingBalanceDetail.fromJson(Map<String, dynamic>json){
    this.id = json['id'] ?? 0;
    this.balance = json['balance'] ?? 0;
  }
}