import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/models/getMobileOperators_response.dart';
import 'package:phonepayz/modules/bottomNavigationBar/main_page.dart';
import 'package:phonepayz/modules/home/plans/plans.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/FadeTransitionPageRouteBuilder.dart';
import 'package:phonepayz/utils/constants.dart';


class AutoRecharge extends StatefulWidget{
  @override
  _AutoRechargePageState createState() => _AutoRechargePageState();
}

class _AutoRechargePageState extends State<AutoRecharge> {
  bool isLoading = false;
  String mobile = "";
  String mobileCode = "";
  String token = "";
  String operatorName= "";
  List<MobileOperators> mobileOperators = [];
  MobileOperators selectedMobileOperator;
  TextEditingController _controller = TextEditingController();

  getButtonWidget(){
    if(isLoading){
      return Loader();
    }else{
      return Text("RECHARGE",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),);
    }
  }

  void getToken() {
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((onValue) {
        print(onValue.token);
        token = onValue.token;
        getMobileOperators();
      });
    }
  }

  getMobileOperators(){
    setState(() {
      isLoading = true;
    });
    ApiProvider().getMobileOperators(token).then((response) {
      mobileOperators = response.operators;
      setState(() {
        isLoading = false;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      Constants().showDialogBlurBg(context: context,msg:error.toString());
    });
  }

  getOperator(){
    setState(() {
      isLoading = true;
    });
    ApiProvider().getOperator(mobile,token).then((response) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      Constants().showDialogBlurBg(context: context,msg:error.toString());
    });
  }

  void showDialogBlurBg({BuildContext context,String msg}){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder:(BuildContext context){
          return new BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: new Container(
              width: width,
              height: height,
              child: CupertinoAlertDialog(
                title: Text('Message',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Quicksand'),),
                content: Padding(
                  padding: const EdgeInsets.only(top:16.0),
                  child: Text(msg,style: TextStyle(fontSize: 14,height: 1.5,fontFamily: 'Quicksand'),textAlign: TextAlign.center,),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child:  Text('Done',style: TextStyle(fontSize: 16,fontFamily: 'Quicksand',fontWeight: FontWeight.bold)),
                    isDefaultAction: true,
                    onPressed: (){
                      Navigator.pushReplacement(context, FadeTransitionPageRouteBuilder(page: MainPage()));
                    },
                  ),
                ],
              ),
              color: Colors.white.withOpacity(0.2),
            ),
          );
        }
    );
  }

  doMobileRecharge(){
    setState(() {
      isLoading = true;
    });
    ApiProvider().doMobileRecharge(mobile, int.parse(_controller.text), mobileCode, token).then((response){
      setState(() {
        isLoading = false;
      });
      if(response.status){
        showDialogBlurBg(
            context: context,
            msg: response.message
        );
      }else{
        Constants().showDialogBlurBg(
            context: context,
            msg: response.message
        );
      }
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      Constants().showDialogBlurBg(
          context: context,
          msg: error.toString()
      );
    });
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
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,size: 24,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: Constants().primaryColor,
        title: Text("Mobile Recharge",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text("Mobile Number",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8,),
                  Container(
                    height: 50,
                    child: TextField(
                      style: TextStyle(letterSpacing: 2),
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      cursorColor: Constants().primaryColor,
                      onChanged: (value){
                        setState(() {
                          mobile = value;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Enter mobile number",
                          contentPadding: EdgeInsets.all(8),
                          hintStyle: TextStyle(fontSize: 14,color: Colors.grey.shade500,letterSpacing: 1),
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
                  SizedBox(height: 16,),
                  Text("Select Operator",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.shade200,
                    ),
                    height: 50,
                    padding: EdgeInsets.only(left: 10,right: 10),
                    child:  Row(
                      children: [
                        Expanded(
                          child: DropdownButton<MobileOperators>(
                              hint: Text("Select Operator",style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                              underline: Container(color: Colors.grey.shade200,),
                              value: selectedMobileOperator,
                              iconEnabledColor: Colors.grey.shade200,
                              iconDisabledColor: Colors.grey.shade200,
                              onChanged: (MobileOperators Value) {
                                setState(() {
                                  selectedMobileOperator = Value;
                                  mobileCode = selectedMobileOperator.code;
                                  operatorName = selectedMobileOperator.name;
                                });
                              },
                              items: List.generate(mobileOperators.length, (index) {
                                return DropdownMenuItem<MobileOperators>(
                                  value: mobileOperators[index],
                                  child: Row(
                                    children: [
                                      Image.network("http://159.65.156.205:3000/"+mobileOperators[index].image,height: 24,width: 24,),
                                      SizedBox(width: 10,),
                                      Text(
                                        mobileOperators[index].name,
                                        style:  TextStyle(color: Colors.black,fontSize: 14),
                                      ),
                                    ],
                                  ),
                                );
                              })
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down,color: Colors.grey.shade500,size: 18,),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Text("Amount",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: TextField(
                            style: TextStyle(letterSpacing: 2),
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            cursorColor: Constants().primaryColor,
                            controller: _controller,
                            maxLength: 4,
                            decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter amount",
                                contentPadding: EdgeInsets.all(8),
                                hintStyle: TextStyle(fontSize: 14,color: Colors.grey.shade500,letterSpacing: 1),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft: Radius.circular(4)),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade200
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft: Radius.circular(4)),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade200
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 48,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(4),bottomRight: Radius.circular(4)),
                          color: Colors.grey.shade200,
                        ),
                        child: FlatButton(
                            onPressed: () async{
                              if(mobile.length == 10){
                                if(selectedMobileOperator != null){
                                  var result = await Navigator.push(context, FadeTransitionPageRouteBuilder(page: PlansPage(mobile: mobile,operator: operatorName,)));
                                  setState(() {
                                    _controller.text = result;
                                  });
                                }else{
                                  Constants().showDialogBlurBg(context: context,msg: "Please select operator");
                                }
                              }else{
                                Constants().showDialogBlurBg(context: context,msg: "Please enter valid mobile number");
                              }
                            },
                            child: Text("Plans",style: TextStyle(color: Constants().primaryColor,fontWeight: FontWeight.bold),)),
                      )
                    ],
                  )
                ],)
          ),
          SafeArea(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 30,left: 20,right: 20),
                height: 46,
                width: double.infinity,
                child: FlatButton(
                    onPressed: isLoading?null:(){
                      if(mobile.length == 10){
                        if(_controller.text.length <= 1){
                          Constants().showDialogBlurBg(
                              context: context,
                              msg: "Amount must contain atleast two characters"
                          );
                        }else{
                          doMobileRecharge();
                        }
                      }else{
                        Constants().showDialogBlurBg(
                            context: context,
                            msg: "Enter your 10 digit mobile number"
                        );
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                    ),
                    color: Constants().primaryColor,
                    child: getButtonWidget()
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
