import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/components/multiStateView.dart';
import 'package:phonepayz/models/getDistributor_response.dart';
import 'package:phonepayz/models/getSuperDistributors_response.dart';
import 'package:phonepayz/modules/distributor/mobile_createDistributor.dart';
import 'package:phonepayz/modules/superDistributor/mobile_createSuperDistributor.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/FadeTransitionPageRouteBuilder.dart';
import 'package:phonepayz/utils/constants.dart';

class MobileDistributor extends StatefulWidget{
  @override
  _MobileDistributorState createState() => _MobileDistributorState();
}

class _MobileDistributorState extends State<MobileDistributor> {
  String token = "";
  List<Distributors> distributors = [];
  ViewState state;
  bool isLoading = false;
  String amount = "";

  getButtonWidget() {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 1.5,
        ),
      );
    } else {
      return Text("Add Money",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),);
    }
  }

  getDistributors(String token){
    ApiProvider().getDistributors(token).then((response) {
      distributors = response.distributors;
      setState(() {
        state = ViewState.Content;
      });
      if(response.status == false){
        Constants().showDialogBlurBg(context: context,msg: response.message);
      }
    }).catchError((error){
      setState(() {
        state = ViewState.Error;
      });
    });
  }
  getToken() {
    setState(() {
      state = ViewState.Loading;
    });
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((val) {
        print(val.token);
        token = val.token;
        getDistributors(val.token);
      });
    }
  }

  showDialogBox(String id){
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: Container(
              height: 220,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text("Add Money",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 20,top: 24),
                    height: 50,
                    child: TextField(
                      cursorColor: Constants().primaryColor,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      onChanged: (val){
                        setState(() {
                          amount = val;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Enter amount",
                          counterText: "",
                          hintStyle: TextStyle(fontSize: 14,color: Colors.grey.shade500),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                    child: FlatButton(
                        onPressed: (){
                          addMoney(id);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: Colors.green.shade500,
                        child: getButtonWidget()
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  addMoney(String id){
    setState(() {
      isLoading = true;
    });
    ApiProvider().addMoney(token, int.parse(amount), id).then((response) async{
      if(response.status){
        await getDistributors(token);
        Navigator.pop(context);
      }else{
        Constants().showDialogBlurBg(context: context,msg: response.message);
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
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
                getDistributors(token);
              },
              child: Text("Retry",style: TextStyle(fontSize: 16,color: Colors.white),)
          )
        ],
      ),
    );
  }
  //getContentWidget
  getContentWidget(){
    return (distributors.isEmpty)?Container():ListView.builder(
      itemCount: distributors.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 20),
      itemBuilder: (context, index){
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Card(
            child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("NAME",style: TextStyle(color: Colors.grey.shade500,fontWeight: FontWeight.bold,fontSize: 11),),
                        SizedBox(height: 4,),
                        Text(distributors[index].name,style: TextStyle(fontSize: 14),),
                        SizedBox(height: 16,),
                        Text("MOBILE NUMBER",style: TextStyle(color: Colors.grey.shade500,fontWeight: FontWeight.bold,fontSize: 11),),
                        SizedBox(height: 4,),
                        Text(distributors[index].mobile,style: TextStyle(fontSize: 14),),
                        SizedBox(height: 16,),
                        Text("ADDRESS",style: TextStyle(color: Colors.grey.shade500,fontWeight: FontWeight.bold,fontSize: 11),),
                        SizedBox(height: 4,),
                        Text(distributors[index].address,style: TextStyle(fontSize: 14),),
                      ],
                    ),
                    Column(
                      children: [
                        FlatButton(
                            onPressed: () {
                              showDialogBox(distributors[index].id);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(color: Colors.green.shade500)
                            ),
                            child: Text("Add Money",style: TextStyle(fontSize: 14,color: Colors.green.shade500),)
                        ),
                        SizedBox(height: 20,),
                        Text("BALANCE",style: TextStyle(color: Colors.grey.shade500,fontWeight: FontWeight.bold,fontSize: 11),),
                        SizedBox(height: 4,),
                        Text("\u20B9 "+distributors[index].balance.toString(),style: TextStyle(fontSize: 14,color: Colors.red.shade500),),
                      ],
                    )
                  ],
                )
            ),
          ),
        );
      },
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
          backgroundColor: Constants().primaryColor,
          elevation: 1,
          centerTitle: true,
          title: Text("Distributor",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Constants().primaryColor,
          onPressed: () async{
            await Navigator.push(context, FadeTransitionPageRouteBuilder(page: MobileCreateDistributor()));
            getDistributors(token);
          },
          child: Icon(Icons.add,color: Colors.white,),
        ),
        body: MultiStateView(
          state: state,
          contentView: getContentWidget(),
          errorView: getErrorWidget(),
          loaderView: getLoadingWidget(),
        )
    );
  }
}