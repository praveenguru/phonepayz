import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/modules/adminTransactions/adminTransactions.dart';
import 'package:phonepayz/modules/dashboard/dashboard.dart';
import 'package:phonepayz/modules/distributor/distributor.dart';
import 'package:phonepayz/modules/login/admin_login.dart';
import 'package:phonepayz/modules/refund/refundRequests.dart';
import 'package:phonepayz/modules/retailer/retailer.dart';
import 'package:phonepayz/modules/settings/admin_settings.dart';
import 'package:phonepayz/modules/superDistributor/super_distributor.dart';
import 'package:phonepayz/utils/FadeTransitionPageRouteBuilder.dart';

class AdminHome extends StatefulWidget{
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>{
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: AppBar(
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title:  Container(
                margin: EdgeInsets.only(left: 20),
                child: Image.asset("images/logo.png",height: 30,),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 20,top: 10,bottom: 10),
                  child: FlatButton(
                      onPressed: () async{
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(context, FadeTransitionPageRouteBuilder(page: AdminLogin()));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      color: Colors.red.shade500,
                      child: Text("Log Out",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)
                  ),
                ),
              ],
              flexibleSpace: Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TabBar(
                        indicatorColor: Colors.white,
                        labelStyle: TextStyle(fontSize: 16,fontFamily: 'Quicksand'),
                        isScrollable: true,
                        unselectedLabelStyle: TextStyle(fontSize: 16,fontFamily: 'Quicksand'),
                        indicatorSize: TabBarIndicatorSize.label,
                        physics: BouncingScrollPhysics(),
                        tabs: [
                          Tab(
                            child: Text("Dashboard"),
                          ),
                          Tab(
                            child: Text("Transactions"),
                          ),
                          Tab(
                            child: Text("Refund Requests"),
                          ),
                          Tab(
                            child: Text("Super Distributors"),
                          ),
                          Tab(
                            child: Text("Distributors"),
                          ),
                          Tab(
                            child: Text("Retailers"),
                          ),
                          Tab(
                            child: Text("Settings"),
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.only(left: 30,right: 30),
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                 Dashboard(),
                 AdminTransactions(),
                  RefundRequests(),
                  SuperDistributor(),
                  Distributor(),
                 Retailer(),
                 AdminSettings()
                ],
              ),
            ),
          )
      ),
    );
  }
}


