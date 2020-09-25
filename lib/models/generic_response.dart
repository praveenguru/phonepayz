class GenericResponse{
  bool status;
  String message;
  GenericResponse({this.status,this.message});

  GenericResponse.fromJson(Map<String, dynamic>json){
    this.status = json['status'];
    this.message = json['message'];
  }

  GenericResponse.withError(String errorMessage){
    this.status = false;
    this.message = errorMessage;
  }
}