import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/modules/dashboard/dashboard.dart';
import 'package:phonepayz/modules/distributor/distributor.dart';
import 'package:phonepayz/modules/retailer/retailer.dart';
import 'package:phonepayz/modules/superDistributor/super_distributor.dart';

class AdminHome extends StatefulWidget{
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>{
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                            child: Text("Super Distributors"),
                          ),
                          Tab(
                            child: Text("Distributors"),
                          ),
                          Tab(
                            child: Text("Retailers"),
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
              constraints: BoxConstraints(
                  maxWidth: 900
              ),
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                 Dashboard(),
                 SuperDistributor(),
                 Distributor(),
                 Retailer(),
                ],
              ),
            ),
          )
      ),
    );
  }
}


