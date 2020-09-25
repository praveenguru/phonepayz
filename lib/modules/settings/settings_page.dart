import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/modules/login/mobile_login.dart';
import 'package:phonepayz/utils/FadeTransitionPageRouteBuilder.dart';
import 'package:phonepayz/utils/constants.dart';

class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Constants().primaryColor,
        title: Text("Settings",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20,right: 20,top: 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Privacy Policy",style: TextStyle(fontSize: 16),),
                    Icon(EvaIcons.arrowIosForward,size: 20,color: Colors.grey.shade500,),
                  ],
                ),
                SizedBox(height: 16,),
                Divider(
                  color: Colors.grey.shade300,
                  height: 1,
                ),
                SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Terms & Conditions",style: TextStyle(fontSize: 16),),
                    Icon(EvaIcons.arrowIosForward,size: 20,color: Colors.grey.shade500,),
                  ],
                ),
                SizedBox(height: 16,),
                Divider(
                  color: Colors.grey.shade300,
                  height: 1,
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 48,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 50,left: 20,right: 20),
              child: FlatButton(
                  onPressed: () async{
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, FadeTransitionPageRouteBuilder(page: MobileLogin()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: Colors.red.shade500,
                  child: Text("Log Out",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)
              ),
            ),
          )
        ],
      ),
    );
  }

}