class CustomerInfo{
  int balance;
  String customerName;
  String nextRechargeDate;
  String planName;
  int monthlyRecharge;
  CustomerInfo({this.nextRechargeDate,this.balance,this.customerName,this.planName,this.monthlyRecharge});
  CustomerInfo.fromJson(Map<String, dynamic>json){
    this.balance = json["Balance"] ?? 0;
    this.customerName = json["customerName"] ?? "";
    this.nextRechargeDate = json["NextRechargeDate"] ?? "";
    this.planName = json["planname"] ?? "";
    this.monthlyRecharge = json["MonthlyRecharge"] ?? 0;
  }
  CustomerInfo.withError(String errorMessage){
    this.balance = 0;
    this.customerName = "";
    this.nextRechargeDate = "";
    this.planName = "";
    this.monthlyRecharge = 0;
  }
}