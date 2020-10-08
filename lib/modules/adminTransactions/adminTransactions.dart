import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/components/multiStateView.dart';
import 'package:phonepayz/models/getTransaction_response.dart';
import 'package:phonepayz/modules/adminTransactions/dthTransactions.dart';
import 'package:phonepayz/modules/adminTransactions/mobileTransactions.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';
class AdminTransactions extends StatefulWidget{
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<AdminTransactions> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          SizedBox(height: 20,),
          TabBar(
              indicatorColor: Colors.black,
              labelStyle: TextStyle(fontSize: 16,fontFamily: 'Quicksand'),
              isScrollable: true,
              unselectedLabelStyle: TextStyle(fontSize: 16,fontFamily: 'Quicksand'),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade500,
              physics: BouncingScrollPhysics(),
              onTap: (index){
                setState(() {
                  currentIndex = index;
                });
              },
              tabs: [
                Tab(
                  child: Text("Mobile"),
                ),
                Tab(
                  child: Text("Dth"),
                ),
              ]
          ),
          (currentIndex == 0)?MobileTransactionPage():DthTransactionPage()
        ],
      ),
    );
  }
}







class DTS extends DataTableSource {
  List<Transaction> transactionDetails;
  DTS({this.transactionDetails});
  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [

      ]
    );
  }



  @override
  int get rowCount => transactionDetails.length; // Manipulate this to which ever value you wish

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}