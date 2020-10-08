import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/components/multiStateView.dart';
import 'package:phonepayz/models/getRefundRequests_response.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';

class RefundRequests extends StatefulWidget{
  @override
  _RefundRequestsState createState() => _RefundRequestsState();
}

class _RefundRequestsState extends State<RefundRequests> {
  ViewState viewState;
  String token;
  List<RefundRequest> requests = [];

  void getToken() {
    setState(() {
      viewState = ViewState.Loading;
    });
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((onValue) {
        print(onValue.token);
        token = onValue.token;
        getRefundRequests(token);
      });
    }
  }

  getRefundRequests(String token){
    ApiProvider().getRefundRequests(token).then((response){
      requests = response.refund.reversed.toList();
      setState(() {
        viewState = ViewState.Content;
      });
    }).catchError((error){
      setState(() {
        viewState = ViewState.Error;
      });
    });
  }

  showErrorDialog(String title,String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(title,style: TextStyle(fontSize: 18,fontFamily: 'Quicksand',fontWeight: FontWeight.bold),),
            content: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(message,style: TextStyle(fontSize: 14,fontFamily: 'Quicksand',height: 1.5),textAlign: TextAlign.center,),
            ),
            actions: [
              FlatButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Done",style: TextStyle(fontSize: 14,fontFamily: 'Quicksand',color: Colors.blue),))
            ],
          );
        }
    );
  }

  changeRefundStatus(int status,int id){
    ApiProvider().changeRefundStatus(token,status,id).then((response) async{
      await showErrorDialog("Message", response.message);
      getRefundRequests(token);
    }).catchError((error){
      showErrorDialog("Message", error.toString());
    });
  }

  getContentWidget(){
    return (requests == null)?Container():Column(
      children: [
        SizedBox(height: 30,),
        (requests.isEmpty)?Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Text("No refund requests were found",style: TextStyle(),),
            ],
          ),
        ): Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowHeight: 50,
              dividerThickness: 2,
              headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade50),
              columns: [
                DataColumn(
                  label: Text("Name",style: TextStyle(fontWeight: FontWeight.bold),),
                  numeric: false,
                ),
                DataColumn(
                  label: Text("Amount",style: TextStyle(fontWeight: FontWeight.bold),),
                  numeric: false,
                ),
                DataColumn(
                  label: Text("Mobile",style: TextStyle(fontWeight: FontWeight.bold),),
                  numeric: false,
                ),
                DataColumn(
                  label: Text("Transaction Type",style: TextStyle(fontWeight: FontWeight.bold),),
                  numeric: false,
                ),
                DataColumn(
                  label: Text("Type",style: TextStyle(fontWeight: FontWeight.bold),),
                  numeric: false,
                ),
                DataColumn(
                  label: Text("Api Provider",style: TextStyle(fontWeight: FontWeight.bold),),
                  numeric: false,
                ),
                DataColumn(
                  label: Text("Action",style: TextStyle(fontWeight: FontWeight.bold),),
                  numeric: false,
                ),
              ],
              rows: requests
                  .map(
                    (item) => DataRow(
                    cells: [
                      DataCell(
                        Text(item.transaction.user.name,style: TextStyle(fontSize: 16)),
                      ),
                      DataCell(
                        Text("\u20B9 "+item.transaction.amount.toString(),style: TextStyle(fontSize: 16)),
                      ),
                      DataCell(
                          Row(
                            children: [
                              Image.network(Constants.BASE_URL+"/"+item.transaction.provider.image,height: 32,),
                              SizedBox(width: 8,),
                              Text(item.transaction.mobile+" ( "+item.transaction.provider.name+" )",style: TextStyle(fontSize: 16)),
                            ],
                          )
                      ),
                      DataCell(
                        Text(item.transaction.type,style: TextStyle(fontSize: 16)),
                      ),
                      DataCell(
                        Text(item.transaction.user.type,style: TextStyle(fontSize: 16)),
                      ),
                      DataCell(
                        Text(item.transaction.api_provider,style: TextStyle(fontSize: 16)),
                      ),
                      DataCell(
                        Row(
                          children: [
                            FlatButton(
                              onPressed: () {
                                changeRefundStatus(1,item.id);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: BorderSide(
                                    color: Colors.green.shade500,
                                  )
                              ),
                              child: Text("Accept",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.green.shade500),),
                            ),
                            SizedBox(width: 16,),
                            FlatButton(
                              onPressed: () {
                                changeRefundStatus(0,item.id);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: BorderSide(
                                    color: Colors.red.shade500,
                                  )
                              ),
                              child: Text("Reject",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.red.shade500),),
                            ),
                          ],
                        )
                      ),
                    ]),
              ) .toList(),
            ),
          ),
        ),
      ],
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
                getRefundRequests(token);
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