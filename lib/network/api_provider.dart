import 'package:dio/dio.dart';
import 'package:phonepayz/models/generic_response.dart';
import 'package:phonepayz/models/getDashboard_response.dart';
import 'package:phonepayz/models/getDistributor_response.dart';
import 'package:phonepayz/models/getDthOperators_response.dart';
import 'package:phonepayz/models/getMobileOperators_response.dart';
import 'package:phonepayz/models/getPlans_response.dart';
import 'package:phonepayz/models/getRetailers_response.dart';
import 'package:phonepayz/models/getSuperDistributors_response.dart';
import 'package:phonepayz/models/getTransaction_response.dart';
import 'package:phonepayz/models/getUserDetails_response.dart';
import 'package:phonepayz/utils/constants.dart';



class ApiProvider{
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: Constants.BASE_URL,
      )
  );

  ApiProvider(){
    _dio.interceptors.add(LogInterceptor(responseBody: true,requestBody: true,request:true));
  }


  Future<GetSuperDistributorsResponse> getSuperDistributors(String token) async {
    try {
      Response response = await _dio.get("/super_distributors",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetSuperDistributorsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetSuperDistributorsResponse.fromJson(error.response.data);
      }else return GetSuperDistributorsResponse.withError("some error happened try later");
    }
  }

  Future<GetDistributorsResponse> getDistributors(String token) async {
    try {
      Response response = await _dio.get("/distributors",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetDistributorsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetDistributorsResponse.fromJson(error.response.data);
      }else return GetDistributorsResponse.withError("some error happened try later");
    }
  }

  Future<GetRetailersResponse> getRetailers(String token) async {
    try {
      Response response = await _dio.get("/retailers",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetRetailersResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetRetailersResponse.fromJson(error.response.data);
      }else return GetRetailersResponse.withError("some error happened try later");
    }
  }

  Future<GetMobileOperatorsResponse> getMobileOperators(String token) async {
    try {
      Response response = await _dio.post("/recharges/getMobileOperators",data:{},options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetMobileOperatorsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetMobileOperatorsResponse.fromJson(error.response.data);
      }else return GetMobileOperatorsResponse.withError("some error happened try later");
    }
  }

  Future<GenericResponse> doMobileRecharge(String mobile,int amount,String operator,String token) async {
    try {
      Response response = await _dio.post("/recharges/doMobileRecharge",data: {
        "mobile":mobile,
        "amount":amount,
        "operator_code":operator,
      },options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GenericResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GenericResponse.fromJson(error.response.data);
      }else return GenericResponse.withError("some error happened try later");
    }
  }

  Future<GenericResponse> getOperator(String mobile,String token) async {
    try {
      Response response = await _dio.post("/recharges/getMobileOperator/${(mobile)}",data: {},options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GenericResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GenericResponse.fromJson(error.response.data);
      }else return GenericResponse.withError("some error happened try later");
    }
  }

  Future<GetPlansResponse> getPlans(String mobile,String token,String operator) async {
    try {
      Response response = await _dio.post("/recharges/getMobileOperatorPlans/${mobile}/${operator}",data: {},options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetPlansResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetPlansResponse.fromJson(error.response.data);
      }else return GetPlansResponse.withError("some error happened try later");
    }
  }

  Future<GenericResponse> checkUser(String mobile) async {
    try {
      Response response = await _dio.post("/checkUser",data: {
        "mobile":mobile,
      });
      return GenericResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GenericResponse.fromJson(error.response.data);
      }else return GenericResponse.withError("some error happened try later");
    }
  }


  Future<GenericResponse> doDthRecharge(String number,int amount,String operator,String token) async {
    try {
      Response response = await _dio.post("/recharges/doDthRecharge",data: {
        "number":number,
        "amount":amount,
        "operator_code":operator,
      },options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GenericResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GenericResponse.fromJson(error.response.data);
      }else return GenericResponse.withError("some error happened try later");
    }
  }

  Future<GetDthOperatorsResponse> getDthOperators(String token) async {
    try {
      Response response = await _dio.post("/recharges/getDthOperators",data:{},options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetDthOperatorsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetDthOperatorsResponse.fromJson(error.response.data);
      }else return GetDthOperatorsResponse.withError("some error happened try later");
    }
  }

  Future<GenericResponse> createSuperDistributor(String token, String name, String address, String mobile) async {
    try {
      Response response = await _dio.post("/super_distributors/create",data: {
        "name":name,
        "address":address,
        "mobile":mobile,
      },options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GenericResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GenericResponse.fromJson(error.response.data);
      }else return GenericResponse.withError("some error happened try later");
    }
  }

  Future<GenericResponse> createDistributor(String token, String name, String address, String mobile, String id) async {
    try {
      Response response = await _dio.post("/distributors/create",data: {
        "name":name,
        "address":address,
        "mobile":mobile,
        "super_distributor_id":id,
      },options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GenericResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GenericResponse.fromJson(error.response.data);
      }else return GenericResponse.withError("some error happened try later");
    }
  }

  Future<GenericResponse> createRetailer(String token, String name, String address, String mobile, String id) async {
    try {
      Response response = await _dio.post("/retailers/create",data: {
        "name":name,
        "address":address,
        "mobile":mobile,
        "distributor_id":id,
      },options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GenericResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GenericResponse.fromJson(error.response.data);
      }else return GenericResponse.withError("some error happened try later");
    }
  }



  Future<GenericResponse> addMoney(String token,int amount, String id) async {
    try {
      Response response = await _dio.post("/balance/addBalance",data: {
        "amount": amount,
        "to":id
      },options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GenericResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GenericResponse.fromJson(error.response.data);
      }else return GenericResponse.withError("some error happened try later");
    }
  }

  Future<GetTransactionsResponse> getTransactions(String token) async {
    try {
      Response response = await _dio.get("/users/getTransactions",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetTransactionsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print(error);
      if(error is DioError){
        return GetTransactionsResponse.fromJson(error.response.data);
      }else return GetTransactionsResponse.withError("some error happened try later");
    }
  }

  Future<GetUserDetailsResponse> getUserDetails(String token) async {
    try {
      Response response = await _dio.get("/users/getDetails",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetUserDetailsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetUserDetailsResponse.fromJson(error.response.data);
      }else return GetUserDetailsResponse.withError("some error happened try later");
    }
  }

  Future<Dashboard> getDashboardData(String token) async {
    try {
      Response response = await _dio.get("/users/getDashboardData",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return Dashboard.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return Dashboard.fromJson(error.response.data);
      }else return Dashboard.withError("some error happened try later");
    }
  }
//admin
  Future<GetAdminTransactions> getAllTransactions(String token) async {
    try {
      Response response = await _dio.get("/users/getAllTransactions",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetAdminTransactions.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetAdminTransactions.fromJson(error.response.data);
      }else return GetAdminTransactions.withError("some error happened try later");
    }
  }
}