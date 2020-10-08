import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/components/multiStateView.dart';
import 'package:phonepayz/models/getPlans_response.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';

class PlansPage extends StatefulWidget{
  final String mobile;
  final String operator;
  final String operatorName;
  PlansPage({this.operator,this.mobile,this.operatorName});
  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  String token = "";
  ViewState viewState;
  List<Plans> plans = [];

  void getToken() {
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((onValue) {
        print(onValue.token);
        token = onValue.token;
        getMobilePlans();
      });
    }
  }

  getMobilePlans(){
    setState(() {
      viewState = ViewState.Loading;
    });
    ApiProvider().getPlans(widget.mobile, token, widget.operator).then((response) {
      plans = response.plans;
      setState(() {
        viewState = ViewState.Content;
      });
    }).catchError((error){
      setState(() {
        viewState = ViewState.Error;
      });
    });
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
                getMobilePlans();
              },
              child: Text("Retry",style: TextStyle(fontSize: 16,color: Colors.white),)
          )
        ],
      ),
    );
  }
  //getContentWidget
  getContentWidget(){
    return ListView.builder(
      itemCount: plans.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 20,right: 20,top: 16),
      itemBuilder: (context, index){
        return Container(
          padding: EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Amount:"+" \u20B9 "+plans[index].rs,style: TextStyle(fontWeight: FontWeight.w500),),
                  FlatButton(
                      color: Colors.grey.shade300,
                      onPressed: (){
                        Navigator.pop(context, plans[index].rs);
                      },
                      child: Text("\u20B9 "+plans[index].rs,style: TextStyle(fontWeight: FontWeight.bold),),
                  )
                ],
              ),
              SizedBox(height: 8,),
              Text(plans[index].desc,style: TextStyle(fontSize: 13,height: 1.5,color: Colors.grey.shade600),),
              SizedBox(height: 16,),
              Divider(height: 1,color: Colors.grey.shade400,),
              SizedBox(height: 16,),
            ],
          ),
        );
      },
    );
  }
  @override
  void initState() {
    getToken();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,size: 24,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(widget.operatorName+" Plans",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: MultiStateView(
        state: viewState,
        contentView: getContentWidget(),
        errorView: getErrorWidget(),
        loaderView: getLoadingWidget(),
      ),
    );
  }
}