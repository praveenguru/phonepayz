import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/models/getDthOperators_response.dart';
import 'package:phonepayz/modules/bottomNavigationBar/main_page.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/FadeTransitionPageRouteBuilder.dart';
import 'package:phonepayz/utils/constants.dart';


class DthRechargePage extends StatefulWidget{
  @override
  _DthRechargePageState createState() => _DthRechargePageState();
}

class _DthRechargePageState extends State<DthRechargePage> {
  bool isLoading = false;
  String dthCode = "";
  String dthAmount = "";
  String dth = "";
  String token = "";
  List<DthOperators> dthOperators = [];
  DthOperators selectedDthOperator;

  getButtonWidget(){
    if(isLoading){
      return Loader();
    }else{
      return Text("RECHARGE",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),);
    }
  }

  getDthOperators(){
    setState(() {
      isLoading = true;
    });
    ApiProvider().getDthOperators(token).then((response) {
      dthOperators = response.operators;
      setState(() {
        isLoading = false;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      Constants().showDialogBlurBg(context: context,msg: error.toString());
    });
  }

  void getToken() {
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((onValue) {
        print(onValue.token);
        token = onValue.token;
        getDthOperators();
      });
    }
  }

  doDthRecharge(){
    setState(() {
      isLoading = true;
    });
    ApiProvider().doDthRecharge(dth, int.parse(dthAmount), dthCode, token).then((response){
      setState(() {
        isLoading = false;
      });
      if(response.status){
        Constants().showDialogBlurBg(
            context: context,
            msg: response.message
        );
        Navigator.pushReplacement(context, FadeTransitionPageRouteBuilder(page: MainPage()));
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
          msg: "Something went wrong"
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
        title: Text("Dth Recharge",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text("Dth Number",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
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
                            dth = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "Enter dth number",
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
                    Text("Amount",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                    SizedBox(height: 8,),
                    Container(
                      child: TextField(
                        style: TextStyle(letterSpacing: 2),
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        cursorColor: Constants().primaryColor,
                        onChanged: (value){
                          setState(() {
                            dthAmount = value;
                          });
                        },
                        maxLength: 4,
                        decoration: InputDecoration(
                            hintText: "Enter amount",
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
                      height: 50,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.shade200,
                      ),
                      child:  Row(
                        children: [
                          Expanded(
                            child: DropdownButton<DthOperators>(
                              hint: Text("Select Operator",style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                              underline: Container(color: Colors.grey.shade200,),
                              value: selectedDthOperator,
                              iconEnabledColor: Colors.grey.shade200,
                              iconDisabledColor: Colors.grey.shade200,
                              onChanged: (DthOperators Value) {
                                setState(() {
                                  selectedDthOperator = Value;
                                  dthCode = selectedDthOperator.code;
                                });
                              },
                              items: dthOperators.map((DthOperators operator) {
                                return  DropdownMenuItem<DthOperators>(
                                    value: operator,
                                    child: Row(
                                      children: [
                                        Image.network("http://159.65.156.205:3000/"+operator.image,height: 24,width: 24,),
                                        SizedBox(width: 16,),
                                        Text(
                                          operator.name,
                                          style:  TextStyle(color: Colors.black,fontSize: 14),
                                        ),
                                      ],
                                    )
                                );
                              }).toList(),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down,color: Colors.grey.shade500,size: 18,),
                        ],
                      ),
                    ),
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
                      doDthRecharge();
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