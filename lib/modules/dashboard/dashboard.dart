import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/components/multiStateView.dart';
import 'package:phonepayz/models/getDashboard_response.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ViewState viewState;
  String token = "";
  int super_distributor_count = 0;
  int distributor_count = 0;
  int retailer_count = 0;
  int outstanding_balance = 0;
  int users_count = 0;
  List<OutstandingBalanceDetail> balance = [];
  void getToken() {
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((onValue) {
        print(onValue.token);
        token = onValue.token;
        getDashboardData();
      });
    }
  }

  getDashboardData(){
    setState(() {
      viewState = ViewState.Loading;
    });
    ApiProvider().getDashboardData(token).then((response) {
      super_distributor_count = response.super_distributors_count;
      distributor_count = response.distributors_count;
      retailer_count = response.retailers_count;
      outstanding_balance = response.outstanding_balance;
      users_count = response.users_count;
      balance = response.outstanding_balance_detail;
      setState(() {
        viewState = ViewState.Content;
      });
    }).catchError((error){
      setState(() {
        viewState = ViewState.Error;
      });
    });
  }

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
                getLoadingWidget();
              },
              child: Text("Retry",style: TextStyle(fontSize: 16,color: Colors.white),)
          )
        ],
      ),
    );
  }
  //getContentWidget
  getContentWidget(){
    return (balance == null)? Container() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Card(
          child: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Users",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 40),
                      child: Column(
                        children: [
                          Text("Total Users".toUpperCase(),style: TextStyle(fontSize: 14,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          Text(users_count.toString(),style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text("Super Distributors".toUpperCase(),style: TextStyle(fontSize: 14,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          Text(super_distributor_count.toString(),style: TextStyle(fontSize: 42,),),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text("Distributors".toUpperCase(),style: TextStyle(fontSize: 14,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          Text(distributor_count.toString(),style: TextStyle(fontSize: 42,),),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text("Retailers".toUpperCase(),style: TextStyle(fontSize: 14,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          Text(retailer_count.toString(),style: TextStyle(fontSize: 42,),),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        Card(
          child: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Outstanding Balance Detail",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 40),
                      child: Column(
                        children: [
                          Text("Total Balance".toUpperCase(),style: TextStyle(fontSize: 14,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          Text("\u20B9" + outstanding_balance.toString(),style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    for(var item in balance)
                      Container(
                        child: Column(
                          children: [
                            Text(item.id.toUpperCase(),style: TextStyle(fontSize: 14,color: Colors.grey.shade500,fontWeight: FontWeight.bold),),
                            SizedBox(height: 8,),
                            Text("\u20B9" + item.balance.toString(),style: TextStyle(fontSize: 42,),),
                          ],
                        ),
                      )

                  ],
                ),
              ],
            ),
          ),
        )
      ],
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