import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:phonepayz/modules/bottomNavigationBar/main_page.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';


class MobileLogin extends StatefulWidget{
  @override
  _MobileLoginState createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  String mobileNumber = "";
  int dialCode = 91;
  TextEditingController _controller = TextEditingController();
  String phoneNumber;
  String verificationId;
  bool isCodeSent = false;
  bool isLoading = false;
  String otp = "";

  void verificationCompleted(AuthCredential phoneAuthCredential) {
    print('verificationCompleted');
    handleSignin(phoneAuthCredential);
  }

  void verificationFailed(FirebaseAuthException error) {
    print(error.message);
  }

  void codeSent(String verificationId, [int code]) {
    this.verificationId = verificationId;
    setState(() {
      isCodeSent = true;
      isLoading = false;
    });
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print('codeAutoRetrievalTimeout');
  }

  Future<void> _submitPhoneNumber() async {
    setState(() {
      isLoading = true;
    });
    this.phoneNumber = "+"+dialCode.toString() + mobileNumber;
    print(phoneNumber);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(milliseconds: 10000),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  handleSignin(AuthCredential authCredential) async{
    try {
      await FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .then((UserCredential authRes) {
        var _firebaseUser = authRes.user;
        if(_firebaseUser!=null) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context){ return MainPage();}), (Route<dynamic>route) => false);
        }
      });
    } catch (e) {
      print(e.toString());
      if(e is PlatformException){
        if(e.code == "ERROR_INVALID_VERIFICATION_CODE"){
          Constants().showDialogBlurBg(msg: "The otp entered is not valid",context:context );
        }else Constants().showDialogBlurBg(msg: e.message,context:context );
      }else Constants().showDialogBlurBg(msg: e.toString(),context:context );
    }
  }

  verifyOtp(){
    handleSignin(PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: otp));
  }

  checkUser(){
    setState(() {
      isLoading = true;
    });
    ApiProvider().checkUser(mobileNumber).then((response){
      setState(() {
        isLoading = false;
      });
      if(response.status){
        _submitPhoneNumber();
      }else if(response.status == false){
        Constants().showDialogBlurBg(
            context: context,
            msg: "${response.message}"
        );
      }
      print(response.status);
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      Constants().showDialogBlurBg(
          context: context,
          msg: "${error.message}"
      );
    });
  }
  getButtonWidget(){
    if(isLoading){
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 1.5,
        ),
      );
    }else{
      return Text("SUBMIT",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (!isCodeSent)?Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:[
              Colors.indigo.shade700,
              Colors.indigo.shade500,
              Colors.black87,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.only(left: 20,right: 20),
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Center(
                child: Image.asset("images/logo.png",height: 36,),
              ),
              SizedBox(height: 60,),
              Text("Login",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white),),
              SizedBox(height: 4,),
              Text("Login now to make the recharge",style: TextStyle(fontSize: 14,color: Colors.grey.shade300)),
              SizedBox(height: 20,),
              Container(
                height: 46,
                child: TextField(
                  style: TextStyle(letterSpacing: 2),
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  cursorColor: Constants().primaryColor,
                  onChanged: (value){
                    setState(() {
                      mobileNumber = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your mobile number",
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
              SizedBox(height: 30,),
              Container(
                height: 46,
                width: double.infinity,
                child: FlatButton(
                  onPressed: isLoading?null:(){
                    (mobileNumber.length==10)? checkUser():Constants().showDialogBlurBg(
                        context: context,
                        msg: "Enter your 10 digit mobile number"
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  color: Colors.green.shade400,
                  child: getButtonWidget()
                ),
              )
            ],
          ),
        ),
      )):Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors:[
                Colors.indigo.shade700,
                Colors.indigo.shade500,
                Colors.black87,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
        ),
        padding: EdgeInsets.only(left: 20,right: 20),
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
              Center(
                child: Image.asset("images/logo.png",height: 36,),
              ),
              SizedBox(height: 60,),
              Text("Otp",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white),),
              SizedBox(height: 4,),
              Text("Enter your otp to login now",style: TextStyle(fontSize: 14,color: Colors.grey.shade300)),
              SizedBox(height: 20,),
              VerificationCodeInput(
                autofocus: true,
                length: 6,
                textStyle: TextStyle(
                    color: Colors.grey.shade900),
                itemSize: 50,
                onCompleted: (value) {
                  setState(() {
                    otp = value;
                  });
                  verifyOtp();
                },
                itemDecoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8)
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      )
    ));
  }
}