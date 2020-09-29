import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/components/multiStateView.dart';
import 'package:phonepayz/models/getTransaction_response.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';
class AdminTransactions extends StatefulWidget{
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<AdminTransactions> {
  List<AdminTransaction> transactionDetails = [];
  ViewState viewState;
  int pos = 0;
  String image = "";
  MaterialColor statusColor;
  String token;

  void getToken() {
    setState(() {
      viewState = ViewState.Loading;
    });
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((onValue) {
        print(onValue.token);
        token = onValue.token;
        getAllTransactions(onValue.token);
      });
    }
  }

  getAllTransactions(String token){
    ApiProvider().getAllTransactions(token).then((response){
      if(response.status){
        transactionDetails = response.data.reversed.toList();
        setState(() {
          viewState = ViewState.Content;
        });
      }
    }).catchError((error){
      setState(() {
        viewState = ViewState.Error;
      });
    });
  }
  
  getStatusColor(String status){
    status = status.toLowerCase();
    if(status == "success"){
      return Colors.green.shade500;
    }else if(status == "pending"){
      return Colors.purple.shade500;
    }else{
      return Colors.red.shade500;
    }
  }

  //getContentWidget
  getContentWidget(){
    return (transactionDetails == null) ? Container() : SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20,),
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataRowHeight: 50,
                dividerThickness: 2,
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade50),
                columns: [
                  DataColumn(
                    label: Text("Mobile/Dth Number",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Name",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Roll",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Type",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Amount",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Status",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                ],
                rows: transactionDetails
                    .map(
                      (item) => DataRow(
                      cells: [
                        DataCell(
                            Row(
                              children: [
                                Image.network(Constants.BASE_URL+"/"+item.image,height: 32,),
                                SizedBox(width: 8,),
                                Text(item.mobile+" ("+item.operator+")",style: TextStyle(fontSize: 16),),
                              ],
                            )
                        ),
                        DataCell(
                          Text(item.user.name,style: TextStyle(fontSize: 16),),
                        ),
                        DataCell(
                          Text(item.user.type,style: TextStyle(fontSize: 16),),
                        ),
                        DataCell(
                          Text(item.type,style: TextStyle(fontSize: 16),),
                        ),
                        DataCell(
                          Text("\u20B9 "+item.amount.toString(),style: TextStyle(fontSize: 16),),
                        ),
                        DataCell(
                          Text(item.status,style: TextStyle(color: getStatusColor(item.status),fontWeight: FontWeight.bold,fontSize: 16),),
                        ),
                      ]),
                ) .toList(),
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  //getErrorWidget
  getErrorWidget(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Oops something went wrong",style: TextStyle(color: Colors.grey.shade500),),
          SizedBox(height: 10,),
          FlatButton(
              color: Constants().primaryColor,
              onPressed: (){
                getAllTransactions(token);
              },
              child: Text("Retry",style: TextStyle(fontSize: 16,color: Colors.white),)
          )
        ],
      ),
    );
  }

  //getLoadingWidget
  getLoadingWidget(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Loader(),
          SizedBox(height: 8,),
          Text("Please wait")
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }
  @override
  Widget build(BuildContext context) {
    return MultiStateView(
      state: viewState,
      contentView: getContentWidget(),
      loaderView: getLoadingWidget(),
      errorView: getErrorWidget(),
    );
  }
}