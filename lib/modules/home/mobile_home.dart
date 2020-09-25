import 'dart:io';
import 'dart:ui';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/components/multiStateView.dart';
import 'package:phonepayz/models/getUserDetails_response.dart';
import 'package:phonepayz/modules/home/auto/auto.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/FadeTransitionPageRouteBuilder.dart';
import 'package:phonepayz/utils/constants.dart';
import 'dth/dthRecharge_page.dart';
import 'mobile/mobileRecharge_page.dart';


class MobileHome extends StatefulWidget{
  @override
  _MobileHomeState createState() => _MobileHomeState();
}

class HomeCard{
  String title;
  String image;
  HomeCard({@required this.title,@required this.image});
}

class _MobileHomeState extends State<MobileHome> {
  List<HomeCard> card = [
    HomeCard(title: "Mobile", image: "images/smartphone.png"),
    HomeCard(title: "Dth", image: "images/radar.png"),
    HomeCard(title: "Auto", image: "images/smartphone.png"),
  ];

  ViewState state;

  UserDetails user;

  String token = '';

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getUserDetails(String token){
    setState(() {
      state = ViewState.Loading;
    });
    ApiProvider().getUserDetails(token).then((response) {
      if(response.status){
        user = response.data;
        setState(() {
          state = ViewState.Content;
        });
      }else{
        Constants().showDialogBlurBg(context: context,msg: response.message);
      }
    }).catchError((error){
      setState(() {
        state = ViewState.Error;
      });
    });
  }

  void getToken() {
    setState(() {
      state = ViewState.Loading;
    });
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((onValue) {
        print(onValue.token);
        token = onValue.token;
        getUserDetails(onValue.token);
      });
    }
  }

  //getContentWidget
  getContentWidget(){
    return (user == null) ? Container() : SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: AnimationLimiter(
        child: Container(
          padding: EdgeInsets.only(top: 16,left: 16,right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Container(
                  margin: EdgeInsets.only(top: 20,bottom: 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Hi, "+ (user.name),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                      SizedBox(height: 4,),
                      Text("\u20B9 "+ "${user.balance}",style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold,color: Constants().primaryColor),),
                      SizedBox(height: 4,),
                      Text("Your balance",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
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
                        Padding(
                          padding: const EdgeInsets.only(top: 16,left: 16),
                          child: Text("Recharges",style: TextStyle(fontSize: 16,color: Constants().primaryColor,fontWeight: FontWeight.bold),),
                        ),
                        GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 20,
                            ),
                            padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: card.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if(index == 0){
                                    Navigator.push(context, FadeTransitionPageRouteBuilder(page: MobileRechargePage()));
                                  }else if(index == 1){
                                    Navigator.push(context, FadeTransitionPageRouteBuilder(page: DthRechargePage()));
                                  }else{
                                    Navigator.push(context, FadeTransitionPageRouteBuilder(page: AutoRecharge()));
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    //color: Colors.white,
                                    //borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ImageIcon(AssetImage(card[index].image),color: Colors.indigo.shade500,size: 26,),
                                      SizedBox(height: 8,),
                                      Text(card[index].title,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,height: 1.4),textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),
                              );
                            }
                        ),
                      ],),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
                getUserDetails(token);
              },
              child: Text("Retry",style: TextStyle(fontSize: 16,color: Colors.white),)
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryColor,
        elevation: 1,
        centerTitle: true,
        title: Image.asset("images/logo.png",height: 28,),
      ),
      body: MultiStateView(
        state: state,
        loaderView: getLoadingWidget(),
        contentView: getContentWidget(),
        errorView: getErrorWidget(),
      ),
    );
  }
}
