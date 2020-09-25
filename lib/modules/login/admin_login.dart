import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/admin_textfield_filled.dart';
import 'package:phonepayz/components/button_filled.dart';
import 'package:phonepayz/modules/home/admin_home.dart';
import 'package:phonepayz/utils/FadeTransitionPageRouteBuilder.dart';


class AdminLogin extends StatefulWidget{
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  String email = "";
  String password = "";
  bool isLoading = false;

  showDialogBox(String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Alert",style: TextStyle(fontSize: 18,fontFamily: 'Quicksand',fontWeight: FontWeight.bold),),
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

  signIn(){
    setState(() {
      isLoading = true;
    });
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((response){
      showDialogBox("Login Successfull");
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(context, FadeTransitionPageRouteBuilder(page: AdminHome()));
    }).catchError((error){
      showDialogBox(error.toString());
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Login",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
            SizedBox(height: 24,),
            AdminTextFieldFilled(
              obscureText: false,
              onChanged: (val){
                setState(() {
                  email = val;
                });
              },
              hintText: "Enter your email",
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10,),
            AdminTextFieldFilled(
              obscureText: true,
              onChanged: (val){
                setState(() {
                  password = val;
                });
              },
              hintText: "Enter your password",
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20,),
            ButtonFilled(
              onPressed: (){
                signIn();
              },
              buttonText: "SUBMIT",
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}