import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/modules/superDistributor/mobile_superDistributor.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/FadeTransitionPageRouteBuilder.dart';
import 'package:phonepayz/utils/constants.dart';

class MobileCreateSuperDistributor extends StatefulWidget{
  @override
  _MobileCreateSuperDistributorState createState() => _MobileCreateSuperDistributorState();
}

class _MobileCreateSuperDistributorState extends State<MobileCreateSuperDistributor> {
  String token = "";
  String mobile = "";
  String name = "";
  String address = "";
  bool isLoading = false;
  getButtonWidget(){
    if(isLoading){
      return Loader();
    }else{
      return Text("CREATE SUPER DISTRIBUTOR",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),);
    }
  }
  createSuperDistributor() {
    setState(() {
      isLoading = true;
    });
    ApiProvider().createSuperDistributor(token, name, address, mobile).then((response) async{
      setState(() {
        isLoading = false;
      });
      if(response.status){
        await showDialog(
            context: context,
            builder:(BuildContext context){
          return new BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: new Container(
              width:  MediaQuery.of(context).size.width,
              height:  MediaQuery.of(context).size.height,
              child: CupertinoAlertDialog(
                title: Text('Message',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Quicksand'),),
                content: Padding(
                  padding: const EdgeInsets.only(top:16.0),
                  child: Text(response.message,style: TextStyle(fontSize: 14,height: 1.5,fontFamily: 'Quicksand'),textAlign: TextAlign.center,),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child:  Text('Done',style: TextStyle(fontSize: 16,fontFamily: 'Quicksand',fontWeight: FontWeight.bold)),
                    isDefaultAction: true,
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              color: Colors.white.withOpacity(0.2),
            ),
          );
        }
      );
      Navigator.pop(context);
      }else{
        Constants().showDialogBlurBg(context: context,msg: response.message);
      }
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
      });
    }
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
        leading: IconButton(icon: Icon(Icons.keyboard_backspace,size: 24,color: Colors.white,), onPressed: (){
          Navigator.pop(context);
        }),
        title: Text("Create Super Distributor",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text("Super Distributor Name",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
                    child: TextField(
                      autofocus: true,
                      cursorColor: Constants().primaryColor,
                      onChanged: (value){
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Enter super distributor name",
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
                  SizedBox(height: 20,),
                  Text("Mobile Number",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
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
                  SizedBox(height: 20,),
                  Text("Address",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
                    child: TextField(
                      autofocus: true,
                      cursorColor: Constants().primaryColor,
                      onChanged: (value){
                        setState(() {
                          address = value;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Enter address",
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
                  SizedBox(height: 80,),
                ],
              ),
            ),
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
                      createSuperDistributor();
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