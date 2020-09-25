import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Constants {
  Color primaryColor = Colors.indigo.shade500;
  Color secondaryTextColor = Colors.grey.shade500;
  static const BASE_URL="http://159.65.156.205:3000";

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
  }
}