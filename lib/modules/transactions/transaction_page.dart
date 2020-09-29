import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/components/multiStateView.dart';
import 'package:phonepayz/models/getTransaction_response.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';
class TransactionsPage extends StatefulWidget{
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Transaction> transactionDetails = [];
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
        getTransactions(onValue.token);
      });
    }
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
  
  getTransactions(String token){
   ApiProvider().getTransactions(token).then((response){
     if(response.status){
       transactionDetails = response.data.reversed.toList();
       setState(() {
         viewState = ViewState.Content;
       });
     }else{
       Constants().showDialogBlurBg(
           context: context,
           msg: response.message
       );
       print(response.message);
     }
   }).catchError((error){
     setState(() {
       viewState = ViewState.Error;
     });
     print(error);
   });
  }

  //getContentWidget
  getContentWidget(){
    return (transactionDetails.isEmpty) ? Center(
      child: Text("No Transactions",style: TextStyle(color: Colors.grey.shade500,fontSize: 16),),
    ) : SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          AnimationLimiter(
            child: ListView.builder(
              itemCount: transactionDetails.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(left: 20,right: 20),
              itemBuilder: (context,index){
                pos = index;
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    verticalOffset: 40.0,
                    child: FadeInAnimation(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.grey.shade100
                                ),
                                child: Image.network(Constants.BASE_URL+"/"+transactionDetails[index].image,height: 24,width: 24,),
                              ),
                              SizedBox(width: 12,),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(transactionDetails[index].mobile+ " ("+transactionDetails[index].operator+")",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                      SizedBox(height: 4,),
                                      Text(transactionDetails[index].status,style: TextStyle(fontSize: 13,color: getStatusColor(transactionDetails[index].status)),),
                                    ],
                                  )
                              ),
                              Text("\u20B9 "+"${transactionDetails[index].amount}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Constants().primaryColor),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Divider(height: 1,color: Colors.grey.shade300,),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
                getTransactions(token);
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Constants().primaryColor,
        title: Text("Transactions",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: MultiStateView(
        state: viewState,
        contentView: getContentWidget(),
        loaderView: getLoadingWidget(),
        errorView: getErrorWidget(),
      )
    );
  }
}