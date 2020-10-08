import 'package:dio/dio.dart';
import 'package:phonepayz/models/generic_response.dart';
import 'package:phonepayz/models/getDashboard_response.dart';
import 'package:phonepayz/models/getDthCustomerInfo_response.dart';
import 'package:phonepayz/models/getDthOperators_response.dart';
import 'package:phonepayz/models/getDthServiceProviders_response.dart';
import 'package:phonepayz/models/getMobileOperators_response.dart';
import 'package:phonepayz/models/getMobileServiceProviders_response.dart';
import 'package:phonepayz/models/getPlans_response.dart';
import 'package:phonepayz/models/getRefundRequests_response.dart';
import 'package:phonepayz/models/getTransaction_response.dart';
import 'package:phonepayz/models/getUserDetails_response.dart';
import 'package:phonepayz/models/getUser_response.dart';
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

  //getDashboardData
  Future<Dashboard> getDashboardData(String token) async {
    try {
      Response response = await _dio.get("/user/getDashboardData",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return Dashboard.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return Dashboard.fromJson(error.response.data);
      }else return Dashboard.withError("some error happened try later");
    }
  }

  //getUser
  Future<GetUserResponse> getUser(String token, String type) async {
    try {
      Response response = await _dio.get("/user",queryParameters: {
        "type": type
      },options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetUserResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetUserResponse.fromJson(error.response.data);
      }else return GetUserResponse.withError("some error happened try later");
    }
  }

  //getUserDetails
  Future<UserDetails> getUserDetails(String token) async {
    try {
      Response response = await _dio.get("/user/detail",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return UserDetails.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return UserDetails.fromJson(error.response.data);
      }else return UserDetails.withError("some error happened try later");
    }
  }

  //createUser
  Future<GenericResponse> addUser(String token, String type, String name, String mobile, String address, int parent) async {
    try {
      Response response = await _dio.post("/user",data: {
        "name": name,
        "address": address,
        "mobile": mobile,
        "type": type,
        "parent": parent,
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

  Future<GetMobileServiceProviders> getMobileServiceProviders(String token) async {
    try {
      Response response = await _dio.get("/transaction/getMobileServiceProviders",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetMobileServiceProviders.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetMobileServiceProviders.fromJson(error.response.data);
      }else return GetMobileServiceProviders.withError("some error happened try later");
    }
  }

  Future<GetDthServiceProviders> getDthServiceProviders(String token) async {
    try {
      Response response = await _dio.get("/transaction/getDthServiceProviders",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetDthServiceProviders.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetDthServiceProviders.fromJson(error.response.data);
      }else return GetDthServiceProviders.withError("some error happened try later");
    }
  }

  Future<GenericResponse> changeMobileServiceProvider(String token,String api,int id) async {
    try {
      Response response = await _dio.post("/transaction/changeMobileServiceProvider",data: {
        "api": api,
        "id": id,
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

  Future<GenericResponse> changeDthServiceProvider(String token,String api,int id) async {
    try {
      Response response = await _dio.post("/transaction/changeDthServiceProvider",data: {
        "api": api,
        "id": id,
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

  //addMoney
  Future<GenericResponse> addMoney(String token,int amount, int id) async {
    try {
      Response response = await _dio.post("/user/addBalance",data: {
        "amount": amount,
        "receiver_id": id
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

  //transaction -admin
  Future<GetTransactionsResponse> getAllTransactions(String token, String type) async {
    try {
      Response response = await _dio.get("/transaction",queryParameters: {
        "type": type
      },options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetTransactionsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetTransactionsResponse.fromJson(error.response.data);
      }else return GetTransactionsResponse.withError("some error happened try later");
    }
  }



  Future<GetPlansResponse> getPlans(String mobile,String token,String operator) async {
    try {
      Response response = await _dio.get("/transaction/getMobileOperatorPlans/${mobile}/${operator}",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetPlansResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetPlansResponse.fromJson(error.response.data);
      }else return GetPlansResponse.withError("some error happened try later");
    }
  }

  Future<GetRefundRequestsResponse> getRefundRequests(String token) async {
    try {
      Response response = await _dio.get("/transaction/refundRequests",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return GetRefundRequestsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return GetRefundRequestsResponse.fromJson(error.response.data);
      }else return GetRefundRequestsResponse.withError("some error happened try later");
    }
  }

  Future<CustomerInfo> getDthCustomerInfo(String id,String token,String operator) async {
    try {
      Response response = await _dio.get("/transaction/getDthCustomerInfo/${id}/${operator}",options: Options(headers: {
        "Authorization": 'Bearer $token'
      }));
      return CustomerInfo.fromJson(response.data);
    } catch (error, stacktrace) {
      if(error is DioError){
        return CustomerInfo.fromJson(error.response.data);
      }else return CustomerInfo.withError("some error happened try later");
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

  Future<GenericResponse> changeRefundStatus(String token,int status,int id) async {
    try {
      Response response = await _dio.put("/transaction/changeRefundRequest",queryParameters: {
        "status":status,
        "id":id
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

}