import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/components/multiStateView.dart';
import 'package:phonepayz/models/getUserDetails_response.dart';
import 'package:phonepayz/modules/distributor/mobil_distributor.dart';
import 'package:phonepayz/modules/home/mobile_home.dart';
import 'package:phonepayz/modules/settings/settings_page.dart';
import 'package:phonepayz/modules/superDistributor/mobile_superDistributor.dart';
import 'package:phonepayz/modules/transactions/transaction_page.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';
class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  UserDetails user;
  ViewState state;
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
  //getContentWidget
  getContentWidget(){
    return (user == null) ? Container() : Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Constants().primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 10),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.home),
              title: Text('Home')
          ),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.smartphoneOutline),
              title: Text('Transactions')
          ),
          if(user.type == "SuperDistributor")BottomNavigationBarItem(
              icon: Icon(EvaIcons.smartphoneOutline),
              title: Text('Super Distributor')
          ),
          if(user.type == "SuperDistributor" || user.type == "Distributor")BottomNavigationBarItem(
              icon: Icon(EvaIcons.smartphoneOutline),
              title: Text('Distributor')
          ),
          if(user.type != "SuperDistributor")BottomNavigationBarItem(
              icon: Icon(FeatherIcons.settings),
              title: Text('Settings')
          ),
        ],
      ),
      body: getIndex(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: MultiStateView(
            state: state,
            contentView: getContentWidget(),
            errorView: getErrorWidget(),
            loaderView: getLoadingWidget()
        )
    );
  }
  getIndex(){
    if(currentIndex == 0){
      return MobileHome(user: user);
    }else if(currentIndex == 1){
      return TransactionsPage();
    }else if(currentIndex == 2){
      if(user.type == "SuperDistributor"){
        return MobileSuperDistributor();
      }else if(user.type == "Distributor"){
        return Container();
      }else{
        return SettingsPage();
      }
    }else if(currentIndex == 3){
      if(user.type == "SuperDistributor"){
        return MobileDistributor();
      }else if(user.type == "Distributor"){
        return MobileDistributor();
      }else{
        return SettingsPage();
      }
    }
  }
}